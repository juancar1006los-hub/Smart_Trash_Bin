-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 09, 2026 at 04:55 AM
-- Server version: 9.7.0
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uas_smart_trash_bin`
--

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_pengangkutan`
--

CREATE TABLE `jadwal_pengangkutan` (
  `id_jadwal` int NOT NULL,
  `id_bin` int DEFAULT NULL,
  `id_petugas` int DEFAULT NULL,
  `tanggal_pengangkutan` date DEFAULT NULL,
  `status_jadwal` varchar(20) DEFAULT 'MENUNGGU'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jadwal_pengangkutan`
--

INSERT INTO `jadwal_pengangkutan` (`id_jadwal`, `id_bin`, `id_petugas`, `tanggal_pengangkutan`, `status_jadwal`) VALUES
(1, 2, 1, '2026-06-06', 'MENUNGGU'),
(2, 4, 2, '2026-06-06', 'MENUNGGU'),
(3, 1, 3, '2026-06-06', 'SELESAI'),
(4, 3, 4, '2026-06-06', 'SELESAI'),
(5, 5, 5, '2026-06-06', 'MENUNGGU');

-- --------------------------------------------------------

--
-- Table structure for table `lokasi`
--

CREATE TABLE `lokasi` (
  `id_lokasi` int NOT NULL,
  `nama_lokasi` varchar(100) NOT NULL,
  `alamat` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lokasi`
--

INSERT INTO `lokasi` (`id_lokasi`, `nama_lokasi`, `alamat`) VALUES
(1, 'Gedung A', 'Area Kampus A'),
(2, 'Gedung B', 'Area Kampus B'),
(3, 'Gedung C', 'Area Kampus C'),
(4, 'Gedung D', 'Area Kampus D'),
(5, 'Gedung E', 'Area Kampus E');

-- --------------------------------------------------------

--
-- Table structure for table `petugas`
--

CREATE TABLE `petugas` (
  `id_petugas` int NOT NULL,
  `nama_petugas` varchar(100) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `petugas`
--

INSERT INTO `petugas` (`id_petugas`, `nama_petugas`, `no_hp`, `email`) VALUES
(1, 'Budi', '081111111111', 'budi@gmail.com'),
(2, 'Andi', '082222222222', 'andi@gmail.com'),
(3, 'Siti', '083333333333', 'siti@gmail.com'),
(4, 'Rina', '084444444444', 'rina@gmail.com'),
(5, 'Doni', '085555555555', 'doni@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `riwayat_pengangkutan`
--

CREATE TABLE `riwayat_pengangkutan` (
  `id_riwayat` int NOT NULL,
  `id_jadwal` int DEFAULT NULL,
  `tanggal_selesai` date DEFAULT NULL,
  `berat_diangkut` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `riwayat_pengangkutan`
--

INSERT INTO `riwayat_pengangkutan` (`id_riwayat`, `id_jadwal`, `tanggal_selesai`, `berat_diangkut`) VALUES
(1, 1, '2026-06-06', '28.00'),
(2, 2, '2026-06-06', '30.00'),
(3, 3, '2026-06-06', '15.00'),
(4, 4, '2026-06-06', '12.00'),
(5, 5, '2026-06-06', '10.00');

-- --------------------------------------------------------

--
-- Table structure for table `sensor_data`
--

CREATE TABLE `sensor_data` (
  `id_sensor` int NOT NULL,
  `id_bin` int DEFAULT NULL,
  `kapasitas_terisi` int DEFAULT NULL,
  `berat_sampah` decimal(10,2) DEFAULT NULL,
  `waktu_baca` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `sensor_data`
--

INSERT INTO `sensor_data` (`id_sensor`, `id_bin`, `kapasitas_terisi`, `berat_sampah`, `waktu_baca`) VALUES
(1, 1, 60, '15.00', '2026-06-06 02:15:39'),
(2, 2, 95, '28.00', '2026-06-06 02:15:39'),
(3, 3, 50, '12.00', '2026-06-06 02:15:39'),
(4, 4, 98, '30.00', '2026-06-06 02:15:39'),
(5, 5, 45, '10.00', '2026-06-06 02:15:39');

-- --------------------------------------------------------

--
-- Table structure for table `trash_bin`
--

CREATE TABLE `trash_bin` (
  `id_bin` int NOT NULL,
  `nama_bin` varchar(100) NOT NULL,
  `kapasitas_maks` int NOT NULL,
  `status_bin` varchar(20) DEFAULT 'NORMAL',
  `id_lokasi` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `trash_bin`
--

INSERT INTO `trash_bin` (`id_bin`, `nama_bin`, `kapasitas_maks`, `status_bin`, `id_lokasi`) VALUES
(1, 'BIN-01', 100, 'NORMAL', 1),
(2, 'BIN-02', 100, 'PENUH', 2),
(3, 'BIN-03', 100, 'NORMAL', 3),
(4, 'BIN-04', 100, 'PENUH', 4),
(5, 'BIN-05', 100, 'NORMAL', 5);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_user` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) DEFAULT 'USER'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_user`, `username`, `password`, `role`) VALUES
(1, 'admin', 'admin123', 'Admin'),
(2, 'petugas1', 'petugas123', 'Petugas'),
(3, 'user1', 'user123', 'User'),
(4, 'JueViole', '06062026', 'CEO');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jadwal_pengangkutan`
--
ALTER TABLE `jadwal_pengangkutan`
  ADD PRIMARY KEY (`id_jadwal`),
  ADD KEY `id_bin` (`id_bin`),
  ADD KEY `id_petugas` (`id_petugas`);

--
-- Indexes for table `lokasi`
--
ALTER TABLE `lokasi`
  ADD PRIMARY KEY (`id_lokasi`);

--
-- Indexes for table `petugas`
--
ALTER TABLE `petugas`
  ADD PRIMARY KEY (`id_petugas`),
  ADD UNIQUE KEY `no_hp` (`no_hp`);

--
-- Indexes for table `riwayat_pengangkutan`
--
ALTER TABLE `riwayat_pengangkutan`
  ADD PRIMARY KEY (`id_riwayat`),
  ADD KEY `id_jadwal` (`id_jadwal`);

--
-- Indexes for table `sensor_data`
--
ALTER TABLE `sensor_data`
  ADD PRIMARY KEY (`id_sensor`),
  ADD KEY `id_bin` (`id_bin`);

--
-- Indexes for table `trash_bin`
--
ALTER TABLE `trash_bin`
  ADD PRIMARY KEY (`id_bin`),
  ADD KEY `id_lokasi` (`id_lokasi`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jadwal_pengangkutan`
--
ALTER TABLE `jadwal_pengangkutan`
  MODIFY `id_jadwal` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `lokasi`
--
ALTER TABLE `lokasi`
  MODIFY `id_lokasi` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `petugas`
--
ALTER TABLE `petugas`
  MODIFY `id_petugas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `riwayat_pengangkutan`
--
ALTER TABLE `riwayat_pengangkutan`
  MODIFY `id_riwayat` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `sensor_data`
--
ALTER TABLE `sensor_data`
  MODIFY `id_sensor` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `trash_bin`
--
ALTER TABLE `trash_bin`
  MODIFY `id_bin` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `jadwal_pengangkutan`
--
ALTER TABLE `jadwal_pengangkutan`
  ADD CONSTRAINT `jadwal_pengangkutan_ibfk_1` FOREIGN KEY (`id_bin`) REFERENCES `trash_bin` (`id_bin`),
  ADD CONSTRAINT `jadwal_pengangkutan_ibfk_2` FOREIGN KEY (`id_petugas`) REFERENCES `petugas` (`id_petugas`);

--
-- Constraints for table `riwayat_pengangkutan`
--
ALTER TABLE `riwayat_pengangkutan`
  ADD CONSTRAINT `riwayat_pengangkutan_ibfk_1` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_pengangkutan` (`id_jadwal`);

--
-- Constraints for table `sensor_data`
--
ALTER TABLE `sensor_data`
  ADD CONSTRAINT `sensor_data_ibfk_1` FOREIGN KEY (`id_bin`) REFERENCES `trash_bin` (`id_bin`) ON DELETE CASCADE;

--
-- Constraints for table `trash_bin`
--
ALTER TABLE `trash_bin`
  ADD CONSTRAINT `trash_bin_ibfk_1` FOREIGN KEY (`id_lokasi`) REFERENCES `lokasi` (`id_lokasi`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
