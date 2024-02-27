-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 27 Feb 2024 pada 14.56
-- Versi server: 10.4.28-MariaDB
-- Versi PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_kasir`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `total_harga_transaksi` ()   BEGIN
SELECT 
SUM(tb_keranjang.jumlah*tb_keranjang.harga) AS total_harga
FROM tb_keranjang;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'maulida', '123'),
(2, 'admin', '12345');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_databarang`
--

CREATE TABLE `tb_databarang` (
  `kode_barang` int(50) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(10) NOT NULL,
  `stok` int(10) NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tb_databarang`
--

INSERT INTO `tb_databarang` (`kode_barang`, `nama_barang`, `harga`, `stok`, `tanggal`) VALUES
(1, 'Mochacino', 70000, 44, '2024-02-15'),
(2, 'Americano', 80000, 43, '2024-02-05'),
(3, 'French Fries', 50000, 76, '2024-02-19'),
(4, 'Latte Coffe', 75000, 93, '2024-02-12'),
(5, 'Spagetti', 25000, 50, '2024-03-06'),
(6, 'Burger', 60000, 12, '2024-01-08'),
(2025, 'Ramen', 30000, 10, '2024-02-05'),
(2026, 'Ikan', 10000, 20, '2024-02-27'),
(2028, 'Ikan', 10000, 20, '2024-02-27');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_datapetugas`
--

CREATE TABLE `tb_datapetugas` (
  `id_petugas` int(11) NOT NULL,
  `nama_petugas` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `tanggal_pendaftaran` date NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tb_datapetugas`
--

INSERT INTO `tb_datapetugas` (`id_petugas`, `nama_petugas`, `email`, `alamat`, `tanggal_pendaftaran`, `username`, `password`) VALUES
(16, 'Fathiya', 'maulidafathiya@gmail.com', 'Kuningan', '2024-02-25', 'fathiya', '321'),
(17, 'Mely', 'mely@gmail.com', 'Jalaksana', '2024-02-26', 'Melyska', 'lukmanganteng'),
(18, 'Arga Pratama', 'arga@gmail.com', 'Cilimus', '2024-02-26', 'egoyy', '1111'),
(21, 'Zaen', 'z@gmail.com', 'Darma', '2024-02-26', 'Zaen', '070506');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_keranjang`
--

CREATE TABLE `tb_keranjang` (
  `id_transaksi` int(11) NOT NULL,
  `kode_barang` int(10) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(10) NOT NULL,
  `jumlah` int(10) NOT NULL,
  `total_harga` int(10) NOT NULL,
  `tgl_transaksi` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tb_keranjang`
--

INSERT INTO `tb_keranjang` (`id_transaksi`, `kode_barang`, `nama_barang`, `harga`, `jumlah`, `total_harga`, `tgl_transaksi`) VALUES
(2, 3, 'French Fries', 50000, 2, 100000, '2024-02-27');

--
-- Trigger `tb_keranjang`
--
DELIMITER $$
CREATE TRIGGER `cancel` AFTER DELETE ON `tb_keranjang` FOR EACH ROW BEGIN
UPDATE tb_databarang SET
stok = stok + OLD.jumlah
WHERE kode_barang = OLD.kode_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cancel_2` AFTER DELETE ON `tb_keranjang` FOR EACH ROW BEGIN
DELETE FROM transaksi
WHERE kode_barang = OLD.kode_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `stok_habis` AFTER INSERT ON `tb_keranjang` FOR EACH ROW BEGIN
DELETE FROM tb_databarang
WHERE stok = 0
AND
kode_barang = NEW.kode_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `tgl_transaksi` date NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `kode_barang` int(50) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(11) NOT NULL,
  `jumlah_barang` int(10) NOT NULL,
  `total_harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`tgl_transaksi`, `id_transaksi`, `kode_barang`, `nama_barang`, `harga`, `jumlah_barang`, `total_harga`) VALUES
('2024-02-27', 1, 6, 'Burger', 60000, 1, 60000),
('2024-02-27', 2, 3, 'French Fries', 50000, 2, 100000);

--
-- Trigger `transaksi`
--
DELIMITER $$
CREATE TRIGGER `keranjang` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
INSERT INTO tb_keranjang SET
id_transaksi = NEW.id_transaksi,
kode_barang = NEW.kode_barang,
nama_barang = NEW.nama_barang,
harga = NEW.harga,
jumlah = NEW.jumlah_barang,
total_harga = NEW.total_harga,
tgl_transaksi = NEW.tgl_transaksi;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `transaksi` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
UPDATE tb_databarang SET
stok = stok - NEW.jumlah_barang
WHERE kode_barang = NEW.kode_barang;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `tb_databarang`
--
ALTER TABLE `tb_databarang`
  ADD PRIMARY KEY (`kode_barang`);

--
-- Indeks untuk tabel `tb_datapetugas`
--
ALTER TABLE `tb_datapetugas`
  ADD PRIMARY KEY (`id_petugas`);

--
-- Indeks untuk tabel `tb_keranjang`
--
ALTER TABLE `tb_keranjang`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `kode_barang` (`kode_barang`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `kode_barang` (`kode_barang`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `tb_databarang`
--
ALTER TABLE `tb_databarang`
  MODIFY `kode_barang` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2029;

--
-- AUTO_INCREMENT untuk tabel `tb_datapetugas`
--
ALTER TABLE `tb_datapetugas`
  MODIFY `id_petugas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT untuk tabel `tb_keranjang`
--
ALTER TABLE `tb_keranjang`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
