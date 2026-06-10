from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
import os

app = Flask(__name__)
CORS(app) 

def get_db_connection():
    return mysql.connector.connect(
        host=os.environ.get('DB_HOST', 'localhost'),
        port=int(os.environ.get('DB_PORT', 4000)),  
        user=os.environ.get('DB_USER', 'root'),
        password=os.environ.get('DB_PASS', ''),
        database=os.environ.get('DB_NAME', 'smart_trash_bin'), 
        ssl_verify_cert=True,
        ssl_verify_identity=True
    )

@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    _username = data['username']
    _password = data['password']

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM users WHERE username = %s AND password = %s", (_username, _password))
    user_data = cursor.fetchone()
    
    cursor.close()
    conn.close()

    if user_data:
        # Jika data ditemukan di database, login berhasil
        return jsonify({
            "status": "success", 
            "role": user_data['role']
        })
    else:
        # Jika data kosong (tidak cocok), kembalikan pesan error
        return jsonify({
            "status": "error", 
            "message": "Username atau Password salah! Tanya Juan"
        }), 401

@app.route('/api/dashboard', methods=['GET'])
def get_dashboard_stats():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Menghitung total bin
    cursor.execute("SELECT COUNT(*) as total_bin FROM trash_bin")
    total_bin = cursor.fetchone()['total_bin']
    
    # Menghitung bin yang penuh
    cursor.execute("SELECT COUNT(*) as bin_penuh FROM trash_bin WHERE status_bin='PENUH'")
    bin_penuh = cursor.fetchone()['bin_penuh']
    
    # Menghitung total sampah dari sensor
    cursor.execute("SELECT SUM(berat_sampah) as total_sampah FROM sensor_data")
    total_sampah = cursor.fetchone()['total_sampah'] or 0
    
    cursor.close()
    conn.close()
    return jsonify({"total_bin": total_bin, "bin_penuh": bin_penuh, "total_sampah": total_sampah})

@app.route('/api/chart', methods=['GET'])
def get_chart_data():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    # JOIN untuk menyatukan nama bin dengan kapasitas terisinya
    cursor.execute("""
        SELECT t.nama_bin, s.kapasitas_terisi 
        FROM trash_bin t 
        LEFT JOIN sensor_data s ON t.id_bin = s.id_bin
    """)
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(data)

@app.route('/api/lokasi', methods=['GET'])
def get_lokasi():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM lokasi")
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(data)

@app.route('/api/petugas', methods=['GET'])
def get_petugas():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM petugas")
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(data)

@app.route('/api/jadwal', methods=['GET'])
def get_jadwal():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    # JOIN agar tabel menampilkan Nama Bin & Nama Petugas, bukan sekadar ID angka
    cursor.execute("""
        SELECT j.id_jadwal, t.nama_bin, p.nama_petugas, j.tanggal_pengangkutan, j.status_jadwal 
        FROM jadwal_pengangkutan j
        JOIN trash_bin t ON j.id_bin = t.id_bin
        JOIN petugas p ON j.id_petugas = p.id_petugas
    """)
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(data)

@app.route('/api/riwayat', methods=['GET'])
def get_riwayat():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    # Multi-JOIN untuk mencapai nama_bin dari tabel riwayat
    cursor.execute("""
        SELECT r.id_riwayat, t.nama_bin, r.tanggal_selesai, r.berat_diangkut
        FROM riwayat_pengangkutan r
        JOIN jadwal_pengangkutan j ON r.id_jadwal = j.id_jadwal
        JOIN trash_bin t ON j.id_bin = t.id_bin
    """)
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
