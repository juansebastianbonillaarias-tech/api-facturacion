// Funciones para consumir la API
const API = 'http://localhost:3000';

// Cargar empresas en el select
async function cargarEmpresas() {
  const res = await fetch(API + '/empresas');
  const empresas = await res.json();
  const select = document.getElementById('empresaSelect');
  select.innerHTML = empresas.map(e => `<option value="${e.id_empresa}">${e.nombre}</option>`).join('');
}

// Cargar facturas por empresa
async function cargarFacturasEmpresa() {
  const empresaId = document.getElementById('empresaSelect').value;
  try {
    const res = await fetch(`${API}/facturas/empresa/${empresaId}`);
    if (!res.ok) throw new Error('Error fetching facturas')
    const facturas = await res.json();
    const tbody = document.querySelector('#tablaFacturasEmpresa tbody');
    if (!facturas || facturas.length === 0) {
      tbody.innerHTML = '<tr><td colspan="5" class="text-center">No hay facturas para esta empresa.</td></tr>'
      return
    }
    tbody.innerHTML = facturas.map(f => {
      const fecha = f.fecha ? (new Date(f.fecha)).toLocaleDateString() : ''
      const subtotal = f.subtotal !== undefined ? Number(f.subtotal) : null
      const impuestos = f.total_impuestos !== undefined ? Number(f.total_impuestos) : null
      const total = f.total !== undefined ? Number(f.total) : null
      return `
        <tr>
          <td>${f.id_factura}</td>
          <td>${fecha}</td>
          <td>${subtotal !== null ? formatCurrency(subtotal) : '-'}</td>
          <td>${impuestos !== null ? formatCurrency(impuestos) : '-'}</td>
          <td>${total !== null ? formatCurrency(total) : '-'}</td>
        </tr>
      `
    }).join('')
  } catch (err) {
    const tbody = document.querySelector('#tablaFacturasEmpresa tbody');
    tbody.innerHTML = `<tr><td colspan="5" class="text-danger text-center">Error cargando facturas: ${err.message}</td></tr>`
  }
}

// Cargar facturación mensual
async function cargarFacturacionMensual() {
  try {
    // si hay empresa seleccionada, pedir facturación mensual por empresa
    const empresaId = document.getElementById('empresaSelect') && document.getElementById('empresaSelect').value
    const url = (empresaId && empresaId !== '') ? `${API}/facturas/empresa/${empresaId}/mensual` : (API + '/facturas/mensual')
    const res = await fetch(url);
    if (!res.ok) throw new Error('Error fetching mensual')
    const body = await res.json();
    let mensual = []
    if (Array.isArray(body)) mensual = body
    else if (body && body.data) mensual = body.data

    const tbody = document.querySelector('#tablaMensual tbody');
    if (!mensual || mensual.length === 0) {
      tbody.innerHTML = '<tr><td colspan="2" class="text-center">No hay datos mensuales.</td></tr>'
      return
    }
    tbody.innerHTML = mensual.map(m => {
      const mesNum = Number(m.mes || m.MES || m.month)
      return `
        <tr>
          <td>${monthName(mesNum)}</td>
          <td>${formatCurrency(Number(m.total || 0))}</td>
        </tr>
      `
    }).join('')
  } catch (err) {
    const tbody = document.querySelector('#tablaMensual tbody');
    tbody.innerHTML = `<tr><td colspan="2" class="text-danger text-center">Error: ${err.message}</td></tr>`
  }
}

// Cargar empresas en el select de total
async function cargarEmpresasTotal() {
  const res = await fetch(API + '/empresas');
  const empresas = await res.json();
  const select = document.getElementById('empresaTotalSelect');
  select.innerHTML = empresas.map(e => `<option value="${e.id_empresa}">${e.nombre}</option>`).join('');
}

// Cargar total de facturación por empresa
async function cargarTotalPorEmpresa() {
  try {
    const empresaId = document.getElementById('empresaTotalSelect').value;
    const res = await fetch(`${API}/facturas/empresa/${empresaId}/total`);
    if (!res.ok) throw new Error('Error fetching total')
    const total = await res.json();
    const div = document.getElementById('totalFactura');
    if (total && (total.total !== undefined && total.total !== null)) {
      div.innerHTML = `Subtotal: ${formatCurrency(Number(total.subtotal || 0))} <br> Impuestos: ${formatCurrency(Number(total.impuestos || 0))} <br> Total: ${formatCurrency(Number(total.total || 0))}`;
    } else if (total && total.data && total.data.total_facturas !== undefined) {
      div.innerHTML = `Conteo facturas: ${total.data.total_facturas}`
    } else {
      div.innerHTML = 'No hay facturación para esta empresa.';
    }
  } catch (err) {
    const div = document.getElementById('totalFactura');
    div.innerHTML = `<span class="text-danger">Error: ${err.message}</span>`
  }
}

// Inicializar
window.onload = () => {
  cargarEmpresas();
  cargarEmpresasTotal();
  // precargar datos
  cargarFacturacionMensual();
};

// Helpers
function formatCurrency(v) {
  try { return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP' }).format(Number(v)) } catch (e) { return v }
}

function monthName(n) {
  const names = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic']
  if (!n || n < 1 || n > 12) return n
  return names[n-1]
}
