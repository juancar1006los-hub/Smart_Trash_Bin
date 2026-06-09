CREATE DATABASE smart_trash_bin;
USE smart_trash_bin;

CREATE TABLE lokasi (
    id_lokasi INT AUTO_INCREMENT,
    nama_lokasi VARCHAR(100) NOT NULL,
    alamat VARCHAR(200) NOT NULL,

    PRIMARY KEY (id_lokasi)
);

CREATE TABLE trash_bin (
    id_bin INT AUTO_INCREMENT,
    nama_bin VARCHAR(100) NOT NULL,
    kapasitas_maks INT NOT NULL,
    status_bin VARCHAR(20) DEFAULT 'NORMAL',
    id_lokasi INT,

    PRIMARY KEY (id_bin),

    FOREIGN KEY (id_lokasi)
    REFERENCES lokasi(id_lokasi)
);

CREATE TABLE sensor_data (
    id_sensor INT AUTO_INCREMENT,
    id_bin INT,
    kapasitas_terisi INT,
    berat_sampah DECIMAL(10,2),
    waktu_baca TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_sensor),

    FOREIGN KEY (id_bin)
    REFERENCES trash_bin(id_bin)
);

CREATE TABLE petugas (
    id_petugas INT AUTO_INCREMENT,
    nama_petugas VARCHAR(100) NOT NULL,
    no_hp VARCHAR(20) UNIQUE,

    PRIMARY KEY (id_petugas)
);

ALTER TABLE petugas
ADD email VARCHAR(100);

CREATE TABLE jadwal_pengangkutan (
    id_jadwal INT AUTO_INCREMENT,
    id_bin INT,
    id_petugas INT,
    tanggal_pengangkutan DATE,
    status_jadwal VARCHAR(20) DEFAULT 'MENUNGGU',

    PRIMARY KEY (id_jadwal),

    FOREIGN KEY (id_bin)
    REFERENCES trash_bin(id_bin),

    FOREIGN KEY (id_petugas)
    REFERENCES petugas(id_petugas)
);

CREATE TABLE riwayat_pengangkutan (
    id_riwayat INT AUTO_INCREMENT,
    id_jadwal INT,
    tanggal_selesai DATE,
    berat_diangkut DECIMAL(10,2),

    PRIMARY KEY (id_riwayat),

    FOREIGN KEY (id_jadwal)
    REFERENCES jadwal_pengangkutan(id_jadwal)
);

INSERT INTO lokasi (nama_lokasi, alamat)
VALUES ('Gedung A', 'Area Kampus A');

INSERT INTO lokasi (nama_lokasi, alamat)
VALUES ('Gedung B', 'Area Kampus B');

INSERT INTO lokasi (nama_lokasi, alamat)
VALUES ('Gedung C', 'Area Kampus C');

INSERT INTO lokasi (nama_lokasi, alamat)
VALUES ('Gedung D', 'Area Kampus D');

INSERT INTO lokasi (nama_lokasi, alamat)
VALUES ('Gedung E', 'Area Kampus E');

INSERT INTO trash_bin
(nama_bin, kapasitas_maks, status_bin, id_lokasi)
VALUES ('BIN-01',100,'NORMAL',1);

INSERT INTO trash_bin
(nama_bin, kapasitas_maks, status_bin, id_lokasi)
VALUES ('BIN-02',100,'PENUH',2);

INSERT INTO trash_bin
(nama_bin, kapasitas_maks, status_bin, id_lokasi)
VALUES ('BIN-03',100,'NORMAL',3);

INSERT INTO trash_bin
(nama_bin, kapasitas_maks, status_bin, id_lokasi)
VALUES ('BIN-04',100,'PENUH',4);

INSERT INTO trash_bin
(nama_bin, kapasitas_maks, status_bin, id_lokasi)
VALUES ('BIN-05',100,'NORMAL',5);

INSERT INTO petugas
(nama_petugas,no_hp,email)
VALUES ('Budi','081111111111','budi@gmail.com');

INSERT INTO petugas
(nama_petugas,no_hp,email)
VALUES ('Andi','082222222222','andi@gmail.com');

INSERT INTO petugas
(nama_petugas,no_hp,email)
VALUES ('Siti','083333333333','siti@gmail.com');

INSERT INTO petugas
(nama_petugas,no_hp,email)
VALUES ('Rina','084444444444','rina@gmail.com');

INSERT INTO petugas
(nama_petugas,no_hp,email)
VALUES ('Doni','085555555555','doni@gmail.com');

INSERT INTO sensor_data
(id_bin,kapasitas_terisi,berat_sampah)
VALUES (1,60,15);

INSERT INTO sensor_data
(id_bin,kapasitas_terisi,berat_sampah)
VALUES (2,95,28);

INSERT INTO sensor_data
(id_bin,kapasitas_terisi,berat_sampah)
VALUES (3,50,12);

INSERT INTO sensor_data
(id_bin,kapasitas_terisi,berat_sampah)
VALUES (4,98,30);

INSERT INTO sensor_data
(id_bin,kapasitas_terisi,berat_sampah)
VALUES (5,45,10);

INSERT INTO jadwal_pengangkutan
(id_bin,id_petugas,tanggal_pengangkutan,status_jadwal)
VALUES (2,1,CURDATE(),'MENUNGGU');

INSERT INTO jadwal_pengangkutan
(id_bin,id_petugas,tanggal_pengangkutan,status_jadwal)
VALUES (4,2,CURDATE(),'MENUNGGU');

INSERT INTO jadwal_pengangkutan
(id_bin,id_petugas,tanggal_pengangkutan,status_jadwal)
VALUES (1,3,CURDATE(),'SELESAI');

INSERT INTO jadwal_pengangkutan
(id_bin,id_petugas,tanggal_pengangkutan,status_jadwal)
VALUES (3,4,CURDATE(),'SELESAI');

INSERT INTO jadwal_pengangkutan
(id_bin,id_petugas,tanggal_pengangkutan,status_jadwal)
VALUES (5,5,CURDATE(),'MENUNGGU');

INSERT INTO riwayat_pengangkutan
(id_jadwal,tanggal_selesai,berat_diangkut)
VALUES (1,CURDATE(),28);

INSERT INTO riwayat_pengangkutan
(id_jadwal,tanggal_selesai,berat_diangkut)
VALUES (2,CURDATE(),30);

INSERT INTO riwayat_pengangkutan
(id_jadwal,tanggal_selesai,berat_diangkut)
VALUES (3,CURDATE(),15);

INSERT INTO riwayat_pengangkutan
(id_jadwal,tanggal_selesai,berat_diangkut)
VALUES (4,CURDATE(),12);

INSERT INTO riwayat_pengangkutan
(id_jadwal,tanggal_selesai,berat_diangkut)
VALUES (5,CURDATE(),10);

