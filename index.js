const API_BASE = '/api'; // Alamat server Python Flask Anda

// 1. FUNGSI LOGIN VIA DATABASE/API
async function doLogin() {
    const user = document.getElementById('username').value;
    const pass = document.getElementById('password').value;
    const errorMsg = document.getElementById('login-error');

    try {
        const response = await fetch(`${API_BASE}/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username: user, password: pass })
        });
        
        const data = await response.json();
        
        if (data.status === 'success') {
            document.getElementById('login-page').style.display = 'none';
            document.getElementById('dashboard-page').style.display = 'block';
            document.getElementById('user-profile').innerHTML = `Halo, ${data.role} <i class="fa-solid fa-circle-user"></i>`;
            
            // Muat halaman dashboard secara default
            loadContent('dashboard', { currentTarget: document.querySelector('.menu-item.active') });
        } else {
            errorMsg.innerText = data.message;
            errorMsg.style.display = 'block';
        }
    } catch (error) {
        errorMsg.innerText = "Gagal terhubung ke server Database.";
        errorMsg.style.display = 'block';
    }
}

function logout() {
    document.getElementById('login-page').style.display = 'flex';
    document.getElementById('dashboard-page').style.display = 'none';
    document.getElementById('username').value = '';
    document.getElementById('password').value = '';
}

// 2. FUNGSI NAVIGASI DAN RENDER KONTEN
async function loadContent(menu, event) {
    const contentArea = document.getElementById('dynamic-content');
    
    // Animasi perubahan menu aktif
    if (event && event.currentTarget) {
        document.querySelectorAll('.menu-item').forEach(el => el.classList.remove('active'));
        event.currentTarget.classList.add('active');
    }

    contentArea.innerHTML = '<h3><i class="fa-solid fa-spinner fa-spin"></i> Mengambil data dari database...</h3>';

    try {
        if (menu === 'dashboard') {
            // Ambil data statistik dan grafik bersamaan
            const [statsRes, chartRes] = await Promise.all([
                fetch(`${API_BASE}/dashboard`), fetch(`${API_BASE}/chart`)
            ]);
            const stats = await statsRes.json();
            const chartData = await chartRes.json();

            contentArea.innerHTML = `
                <h2 style="margin-bottom: 20px;">Dashboard Kapasitas</h2>
                <div class="card-container">
                    <div class="card slide-in" style="animation-delay: 0.1s;">
                        <h3>Total Bin</h3><h1 style="color: var(--primary);">${stats.total_bin}</h1>
                    </div>
                    <div class="card slide-in" style="animation-delay: 0.2s;">
                        <h3>Bin Penuh</h3><h1 style="color: red;">${stats.bin_penuh}</h1>
                    </div>
                    <div class="card slide-in" style="animation-delay: 0.3s;">
                        <h3>Total Sampah</h3><h1 style="color: var(--primary);">${stats.total_sampah} Kg</h1>
                    </div>
                </div>
                <div class="chart-container slide-in" style="animation-delay: 0.4s; height: 350px;">
                    <canvas id="binChart"></canvas>
                </div>
            `;
            renderChart(chartData);

        } else if (menu === 'lokasi') {
            const res = await fetch(`${API_BASE}/lokasi`);
            const data = await res.json();
            
            let html = `<h2 style="margin-bottom: 20px;">Data Lokasi Trash Bin</h2><div class="card-container">`;
            data.forEach((item, index) => {
                let delay = (index * 0.1).toFixed(1);
                html += `
                <div class="card slide-in" style="animation-delay: ${delay}s;">
                    <h3 style="color: var(--primary);"><i class="fa-solid fa-building"></i> ${item.nama_lokasi}</h3>
                    <p style="margin-top:10px;"><i class="fa-solid fa-map-pin"></i> ${item.alamat}</p>
                </div>`;
            });
            html += `</div>`;
            contentArea.innerHTML = html;

        } else if (menu === 'petugas') {
            const res = await fetch(`${API_BASE}/petugas`);
            const data = await res.json();

            let tableRows = data.map(p => `
                <tr>
                    <td>${p.id_petugas}</td>
                    <td><b>${p.nama_petugas}</b></td>
                    <td>${p.no_hp}</td>
                    <td>${p.email}</td>
                </tr>
            `).join('');

            contentArea.innerHTML = `
                <h2 style="margin-bottom: 20px;">Data Petugas Kebersihan</h2>
                <div class="table-container slide-in">
                    <table>
                        <tr><th>ID</th><th>Nama Petugas</th><th>No. HP</th><th>Email</th></tr>
                        ${tableRows}
                    </table>
                </div>
            `;

        } else if (menu === 'jadwal') {
            const res = await fetch(`${API_BASE}/jadwal`);
            const data = await res.json();

            let tableRows = data.map(j => {
                let badgeClass = j.status_jadwal === 'SELESAI' ? 'badge-selesai' : 'badge-menunggu';
                // Konversi tanggal dari format API Python
                let dateStr = new Date(j.tanggal_pengangkutan).toLocaleDateString('id-ID'); 
                return `
                <tr>
                    <td><b>${j.nama_bin}</b></td>
                    <td>${j.nama_petugas}</td>
                    <td>${dateStr}</td>
                    <td><span class="${badgeClass}">${j.status_jadwal}</span></td>
                </tr>`;
            }).join('');

            contentArea.innerHTML = `
                <h2 style="margin-bottom: 20px;">Jadwal Pengangkutan</h2>
                <div class="table-container slide-in">
                    <table>
                        <tr><th>Nama Bin</th><th>Petugas</th><th>Tanggal</th><th>Status</th></tr>
                        ${tableRows}
                    </table>
                </div>
            `;

        } else if (menu === 'riwayat') {
            const res = await fetch(`${API_BASE}/riwayat`);
            const data = await res.json();

            let tableRows = data.map(r => {
                let dateStr = new Date(r.tanggal_selesai).toLocaleDateString('id-ID');
                return `
                <tr>
                    <td><b>${r.nama_bin}</b></td>
                    <td>${dateStr}</td>
                    <td><b>${r.berat_diangkut} Kg</b></td>
                </tr>`;
            }).join('');

            contentArea.innerHTML = `
                <h2 style="margin-bottom: 20px;">Riwayat Pengangkutan</h2>
                <div class="table-container slide-in">
                    <table>
                        <tr><th>Nama Bin</th><th>Tanggal Selesai</th><th>Total Berat Diangkut</th></tr>
                        ${tableRows}
                    </table>
                </div>
            `;
        }
    } catch (err) {
        contentArea.innerHTML = `<h3 style="color:red;">Gagal mengambil data dari Database. Pastikan Python Backend berjalan.</h3>`;
    }
}

// 3. FUNGSI PEMBUATAN GRAFIK
function renderChart(dataFromDB) {
    // Memisahkan data dari API menjadi array untuk label dan kapasitas
    const labels = dataFromDB.map(d => d.nama_bin);
    const kapasitas = dataFromDB.map(d => d.kapasitas_terisi || 0);

    const ctx = document.getElementById('binChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Kapasitas Terisi (%)',
                data: kapasitas,
                backgroundColor: '#1abc9c',
                borderRadius: 5
            }]
        },
        options: { 
            responsive: true, maintainAspectRatio: false,
            scales: { y: { beginAtZero: true, max: 100 } }
        }
    });
}