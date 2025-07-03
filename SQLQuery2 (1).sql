-- Tạo cơ sở dữ liệu
CREATE DATABASE QuanLyCuaHangBanSi;
GO

USE QuanLyCuaHangBanSi;
GO

-- Tạo bảng Khách hàng
CREATE TABLE KhachHang (
    MaKH VARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    SDT VARCHAR(15),
    Email VARCHAR(50)
);

-- Tạo bảng Hàng hóa
CREATE TABLE HangHoa (
    MaHH VARCHAR(10) PRIMARY KEY,
    TenHH NVARCHAR(100) NOT NULL,
    DonViTinh NVARCHAR(20),
    SoLuongTon INT DEFAULT 0 CHECK (SoLuongTon >= 0),
    GiaBan DECIMAL(18,2) CHECK (GiaBan >= 0)
);

-- Tạo bảng Đơn đặt hàng
CREATE TABLE DonDatHang (
    MaDDH VARCHAR(10) PRIMARY KEY,
    MaKH VARCHAR(10) NOT NULL,
    NgayDat DATETIME DEFAULT GETDATE(),
    TrangThai NVARCHAR(40) CHECK (TrangThai IN (N'Chờ xử lý', N'Đã duyệt', N'Từ chối', N'Đã giao')),
    TongTien DECIMAL(18,2) DEFAULT 0 CHECK (TongTien >= 0),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Tạo bảng Chi tiết đơn hàng
CREATE TABLE ChiTietDonHang (
    MaCTDH INT IDENTITY(1,1) PRIMARY KEY,
    MaDDH VARCHAR(10) NOT NULL, 
    MaHH VARCHAR(10) NOT NULL,
    SoLuong INT CHECK (SoLuong > 0),
    DonGia DECIMAL(18,2) CHECK (DonGia >= 0),
    ThanhTien AS (SoLuong * DonGia) PERSISTED, -- Sử dụng cột tính toán, Lưu trữ giá trị cột tính toán
    FOREIGN KEY (MaDDH) REFERENCES DonDatHang(MaDDH),
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)
);

-- Tạo bảng Hóa đơn
CREATE TABLE HoaDon (
    MaHD VARCHAR(10) PRIMARY KEY,
    MaDDH VARCHAR(10) NOT NULL,
    NgayLap DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18,2) DEFAULT 0 CHECK (TongTien >= 0),
    DaThanhToan DECIMAL(18,2) DEFAULT 0 CHECK (DaThanhToan >= 0),
    ConNo AS (TongTien - DaThanhToan) PERSISTED, 
    FOREIGN KEY (MaDDH) REFERENCES DonDatHang(MaDDH)
);

-- Tạo bảng Phiếu xuất kho
CREATE TABLE PhieuXuatKho (
    MaPXK VARCHAR(10) PRIMARY KEY,
    MaHD VARCHAR(10) NOT NULL,
    NgayXuat DATETIME DEFAULT GETDATE(),
    NguoiXuat NVARCHAR(50),
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD)
);

-- ===================== DỮ LIỆU MẪU =====================

-- Khách hàng
INSERT INTO KhachHang (MaKH, TenKH, DiaChi, SDT, Email)
VALUES 
('KH001', N'Công ty TNHH Quân ILEST', N'30 Yên Sơn, Chương Mỹ, Hà Nội', '0363195946', 'hanplayer3010@email.com'),
('KH002', N'Cửa hàng bán sỉ', N'Kiến Hưng, Hà Đông, Hà Nội', '0584007888', 'abc@email.com'),
('KH003', N'Siêu thị Big C', N'222 Trần Duy Hưng, Cầu Giấy, Hà Nội', '0242225555', 'bigc@email.com'),
('KH004', N'Cửa hàng tiện lợi Circle K', N'45 Nguyễn Chí Thanh, Đống Đa, Hà Nội', '0243336666', 'circlek@email.com'),
('KH005', N'Đại lý VinMart', N'123 Minh Khai, Hai Bà Trưng, Hà Nội', '0244447777', 'vinmart@email.com');

-- Hàng hóa
INSERT INTO HangHoa (MaHH, TenHH, DonViTinh, SoLuongTon, GiaBan)
VALUES 
('HH001', N'Bánh quy socola', N'Thùng', 100, 150000),
('HH002', N'Nước ngọt Coca Cola', N'Thùng', 200, 200000),
('HH003', N'Kẹo dẻo hương trái cây', N'Thùng', 150, 120000),
('HH004', N'Bia Tiger', N'Thùng', 80, 250000),
('HH005', N'Trà xanh không độ', N'Thùng', 120, 80000),
('HH006', N'Mì gói Hảo Hảo', N'Thùng', 300, 100000),
('HH007', N'Dầu ăn Neptune', N'Thùng', 50, 350000),
('HH008', N'Nước mắm Nam Ngư', N'Thùng', 70, 280000),
('HH009', N'Gạo ST25', N'Bao', 60, 500000),
('HH010', N'Đường trắng', N'Bao', 90, 150000);

-- Đơn đặt hàng
INSERT INTO DonDatHang (MaDDH, MaKH, NgayDat, TrangThai, TongTien)
VALUES 
('DD001', 'KH001', '2023-05-10', N'Chờ xử lý', 1350000),
('DD002', 'KH002', '2023-05-11', N'Đã duyệt', 1200000),
('DD003', 'KH003', '2023-05-12', N'Đã giao', 3000000),
('DD004', 'KH004', '2023-05-13', N'Chờ xử lý', 2000000),
('DD005', 'KH005', '2023-05-14', N'Đã giao', 2500000);

-- Chi tiết đơn hàng
INSERT INTO ChiTietDonHang (MaDDH, MaHH, SoLuong, DonGia)
VALUES 
('DD001', 'HH001', 5, 150000),
('DD001', 'HH002', 3, 200000),
('DD002', 'HH003', 10, 120000),
('DD003', 'HH004', 8, 250000),
('DD003', 'HH005', 10, 80000),
('DD003', 'HH006', 5, 100000),
('DD004', 'HH007', 4, 350000),
('DD004', 'HH008', 2, 280000),
('DD005', 'HH009', 3, 500000),
('DD005', 'HH010', 5, 150000);

-- Hóa đơn
INSERT INTO HoaDon (MaHD, MaDDH, NgayLap, TongTien, DaThanhToan)
VALUES 
('HD001', 'DD001', '2023-05-10', 1350000, 1350000),
('HD002', 'DD002', '2023-05-11', 1200000, 600000),
('HD003', 'DD003', '2023-05-12', 3000000, 3000000),
('HD004', 'DD004', '2023-05-13', 2000000, 1000000),
('HD005', 'DD005', '2023-05-14', 2500000, 2000000);

-- Phiếu xuất kho
INSERT INTO PhieuXuatKho (MaPXK, MaHD, NgayXuat, NguoiXuat)
VALUES 
('PX001', 'HD001', '2023-05-10', N'Nguyễn Văn A'),
('PX002', 'HD002', '2023-05-11', N'Trần Thị B'),
('PX003', 'HD003', '2023-05-12', N'Lê Văn C'),
('PX004', 'HD004', '2023-05-13', N'Phạm Thị D'),
('PX005', 'HD005', '2023-05-14', N'Hoàng Văn E');

-- ===================== THAO TÁC CƠ BẢN (25 CÂU) =====================

-- 1. Thêm khách hàng mới
INSERT INTO KhachHang (MaKH, TenKH, DiaChi, SDT, Email)
VALUES ('KH006', N'Cửa hàng tiện lợi Family Mart', N'789 Lê Văn Lương, Thanh Xuân, Hà Nội', '0245558888', 'familymart@email.com');

-- 2. Thêm hàng hóa mới
INSERT INTO HangHoa (MaHH, TenHH, DonViTinh, SoLuongTon, GiaBan)
VALUES ('HH011', N'Cà phê Trung Nguyên', N'Thùng', 40, 180000);

-- 3. Thêm đơn đặt hàng mới
INSERT INTO DonDatHang (MaDDH, MaKH, TrangThai)
VALUES ('DD006', 'KH006', N'Chờ xử lý');

-- 4. Thêm chi tiết đơn hàng
INSERT INTO ChiTietDonHang (MaDDH, MaHH, SoLuong, DonGia)
VALUES ('DD006', 'HH011', 2, 180000);

-- 5. Thêm hóa đơn
INSERT INTO HoaDon (MaHD, MaDDH, TongTien, DaThanhToan)
VALUES ('HD006', 'DD006', 360000, 0);

-- 6. Thêm phiếu xuất kho
INSERT INTO PhieuXuatKho (MaPXK, MaHD, NguoiXuat)
VALUES ('PX006', 'HD006', N'Nguyễn Thị F');

-- 7. Cập nhật địa chỉ khách hàng
UPDATE KhachHang
SET DiaChi = N'456 Lê Trọng Tấn, Thanh Xuân, Hà Nội'
WHERE MaKH = 'KH006';

-- 8. Cập nhật giá bán hàng hóa
UPDATE HangHoa
SET GiaBan = 160000
WHERE MaHH = 'HH001';

-- 9. Cập nhật trạng thái đơn hàng
UPDATE DonDatHang
SET TrangThai = N'Đã duyệt'
WHERE MaDDH = 'DD006';

-- 10. Cập nhật số lượng tồn kho sau khi xuất
UPDATE HangHoa
SET SoLuongTon = SoLuongTon - 2
WHERE MaHH = 'HH011';

-- 11. Cập nhật số tiền đã thanh toán trong hóa đơn
UPDATE HoaDon
SET DaThanhToan = 360000
WHERE MaHD = 'HD006';

-- 12. Cập nhật người xuất kho
UPDATE PhieuXuatKho
SET NguoiXuat = N'Lê Văn G'
WHERE MaPXK = 'PX006';

-- 13. Xóa một chi tiết đơn hàng (nếu có sai sót)
DELETE FROM ChiTietDonHang
WHERE MaCTDH = 11; -- Giả sử mã chi tiết đơn hàng mới thêm là 11

-- 14. Xóa một đơn đặt hàng chưa xử lý (nếu hủy)
DELETE FROM DonDatHang
WHERE MaDDH = 'DD006' AND TrangThai = N'Chờ xử lý';

-- 15. Xóa một khách hàng chưa có giao dịch
DELETE FROM KhachHang
WHERE MaKH = 'KH006' AND NOT EXISTS (SELECT 1 FROM DonDatHang WHERE MaKH = 'KH006');

-- 16. Truy vấn tất cả khách hàng
SELECT * FROM KhachHang;

-- 17. Truy vấn hàng hóa có giá bán dưới 200,000
SELECT * FROM HangHoa
WHERE GiaBan < 200000;

-- 18. Truy vấn đơn đặt hàng trong tháng 5/2023
SELECT * FROM DonDatHang
WHERE MONTH(NgayDat) = 5 AND YEAR(NgayDat) = 2023;

-- 19. Truy vấn chi tiết đơn hàng của đơn 'DD001'
SELECT * FROM ChiTietDonHang
WHERE MaDDH = 'DD001';

-- 20. Truy vấn hóa đơn chưa thanh toán đủ
SELECT * FROM HoaDon
WHERE ConNo > 0;

-- 21. Truy vấn phiếu xuất kho của một hóa đơn
SELECT * FROM PhieuXuatKho
WHERE MaHD = 'HD001';

-- 22. Truy vấn số lượng hàng tồn kho theo mặt hàng
SELECT MaHH, TenHH, SoLuongTon
FROM HangHoa
ORDER BY SoLuongTon DESC;

-- 23. Truy vấn tổng giá trị hàng tồn kho
SELECT SUM(SoLuongTon * GiaBan) AS TongGiaTriTonKho
FROM HangHoa;

-- 24. Truy vấn đơn hàng đã giao
SELECT * FROM DonDatHang
WHERE TrangThai = N'Đã giao';

-- 25. Truy vấn khách hàng ở Hà Nội
SELECT * FROM KhachHang
WHERE DiaChi LIKE N'%Hà Nội%';

-- 27. Danh sách khách hàng và tổng số đơn hàng đã đặt
SELECT 
    k.MaKH, 
    k.TenKH, 
    COUNT(d.MaDDH) AS SoDonHang
FROM KhachHang k
LEFT JOIN DonDatHang d ON k.MaKH = d.MaKH -- Lấy phần bên trái --
GROUP BY k.MaKH, k.TenKH
ORDER BY SoDonHang DESC;

-- 28. Tổng doanh thu theo từng khách hàng (chỉ đơn đã giao)
SELECT 
    k.MaKH, 
    k.TenKH, 
    SUM(d.TongTien) AS TongDoanhThu
FROM DonDatHang d
JOIN KhachHang k ON d.MaKH = k.MaKH
WHERE d.TrangThai = N'Đã giao'
GROUP BY k.MaKH, k.TenKH
ORDER BY TongDoanhThu DESC;

-- 29. Top 3 mặt hàng bán chạy nhất (số lượng bán nhiều nhất)
SELECT TOP 3
    h.MaHH,
    h.TenHH,
    SUM(c.SoLuong) AS TongSoLuongBan
FROM ChiTietDonHang c
JOIN DonDatHang d ON c.MaDDH = d.MaDDH -- Lấy mã hàng hóa (MaHH) và tên hàng hóa (TenHH) để hiển thị.
JOIN HangHoa h ON c.MaHH = h.MaHH
WHERE d.TrangThai = N'Đã giao'
GROUP BY h.MaHH, h.TenHH
ORDER BY TongSoLuongBan DESC;

-- 30. Doanh thu theo tháng
SELECT 
    YEAR(NgayDat) AS Nam, 
    MONTH(NgayDat) AS Thang, 
    SUM(TongTien) AS DoanhThu
FROM DonDatHang
WHERE TrangThai = N'Đã giao'
GROUP BY YEAR(NgayDat), MONTH(NgayDat)
ORDER BY Nam, Thang;

-- 31. Khách hàng nợ nhiều nhất (còn nợ)
SELECT TOP 1
    k.MaKH,
    k.TenKH,
    SUM(h.ConNo) AS TongNo
FROM HoaDon h
JOIN DonDatHang d ON h.MaDDH = d.MaDDH
JOIN KhachHang k ON d.MaKH = k.MaKH
WHERE h.ConNo > 0
GROUP BY k.MaKH, k.TenKH
ORDER BY TongNo DESC;

-- 32. Mặt hàng có tồn kho ít nhất
SELECT TOP 1
    MaHH,
    TenHH,
    SoLuongTon
FROM HangHoa
ORDER BY SoLuongTon ASC;

-- 33. Tổng số tiền đã thanh toán theo từng tháng
SELECT 
    YEAR(NgayLap) AS Nam, 
    MONTH(NgayLap) AS Thang, 
    SUM(DaThanhToan) AS TongThanhToan
FROM HoaDon
GROUP BY YEAR(NgayLap), MONTH(NgayLap)
ORDER BY Nam, Thang;

-- 34. Đơn đặt hàng có giá trị cao nhất
SELECT TOP 1
    MaDDH,
    MaKH,
    TongTien
FROM DonDatHang
ORDER BY TongTien DESC;

-- 35. Tỷ lệ thanh toán trung bình của khách hàng
SELECT 
    k.MaKH,
    k.TenKH,
    AVG(h.DaThanhToan * 100.0 / NULLIF(h.TongTien,0)) AS TyLeThanhToanTB -- Trả về Null nếu 2 khoá bằng nhau
FROM HoaDon h
JOIN DonDatHang d ON h.MaDDH = d.MaDDH
JOIN KhachHang k ON d.MaKH = k.MaKH
GROUP BY k.MaKH, k.TenKH;

-- 36. Số lượng hàng hóa đã bán theo từng tháng
SELECT 
    YEAR(d.NgayDat) AS Nam,
    MONTH(d.NgayDat) AS Thang,
    h.MaHH,
    h.TenHH,
    SUM(c.SoLuong) AS TongSoLuongBan
FROM ChiTietDonHang c
JOIN DonDatHang d ON c.MaDDH = d.MaDDH
JOIN HangHoa h ON c.MaHH = h.MaHH
WHERE d.TrangThai = N'Đã giao'
GROUP BY YEAR(d.NgayDat), MONTH(d.NgayDat), h.MaHH, h.TenHH
ORDER BY Nam, Thang, TongSoLuongBan DESC;