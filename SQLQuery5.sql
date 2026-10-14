USE master;
GO


IF EXISTS (SELECT name FROM sys.databases WHERE name = N'QuanlySV')
BEGIN
    ALTER DATABASE QuanlySV SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QuanlySV;
END
GO


CREATE DATABASE QuanlySV;
GO

USE QuanlySV;
GO


CREATE TABLE Lop (
    MaLop VARCHAR(20) PRIMARY KEY,
    TenLop NVARCHAR(100) NOT NULL
);
GO


CREATE TABLE Sinhvien (
    MaSV VARCHAR(20) PRIMARY KEY,
    HotenSV NVARCHAR(100) NOT NULL,
    ngaysinh DATE,
    SDT VARCHAR(20),
    Anh NVARCHAR(200),
    MaLop VARCHAR(20) FOREIGN KEY REFERENCES Lop(MaLop) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


INSERT INTO Lop (MaLop, TenLop) VALUES 
('TT1023', N'TT1023 - Tin học D23'),
('TT1D22', N'TT1D22 - Tin học D22'),
('KTPM01', N'KTPM01 - Kỹ thuật PM'),
('HTTT02', N'HTTT02 - HT Thông tin');
GO


INSERT INTO Sinhvien (MaSV, HotenSV, ngaysinh, SDT, Anh, MaLop) VALUES
('SV001', N'Nguyễn Văn An', '2004-04-12', '0912 345 678', '1.jpg', 'TT1023'),
('SV002', N'Trần Thị Mai', '2004-08-20', '0987 654 321', '2.jpg', 'TT1D22'),
('SV003', N'Lê Hoàng Long', '2003-11-18', '0905 112 233', '3.jpg', 'KTPM01'),
('SV004', N'Phạm Thúy Hằng', '2005-02-05', '0973 445 566', '4.jpg', 'HTTT02'),
('SV005', N'Đặng Minh Quân', '2004-06-30', '0936 889 900', '5.jpg', 'TT1023'),
('SV006', N'Vũ Bích Ngọc', '2004-05-14', '0962 123 789', '6.jpg', 'TT1D22');
GO