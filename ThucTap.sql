create DATABASE ThucTap;
USE ThucTap;

CREATE TABLE TBLKhoa
(Makhoa char(10)primary key,
 Tenkhoa char(30),
 Dienthoai char(10));

CREATE TABLE TBLGiangVien(
Magv int primary key,
Hotengv char(30),
Luong decimal(5,2),
Makhoa char(10) references TBLKhoa);

CREATE TABLE TBLSinhVien(
Masv int primary key,
Hotensv char(40),
Makhoa char(10)foreign key references TBLKhoa,
Namsinh int,
Quequan char(30));

CREATE TABLE TBLDeTai(
Madt char(10)primary key,
Tendt char(30),
Kinhphi int,
Noithuctap char(30));

CREATE TABLE TBLHuongDan(
Masv int primary key,
Madt char(10)foreign key references TBLDeTai,
Magv int foreign key references TBLGiangVien,
KetQua decimal(5,2));

INSERT INTO TBLKhoa VALUES
('Geo','Dia ly va QLTN',3855413),
('Math','Toan',3855411),
('Bio','Cong nghe Sinh hoc',3855412);

INSERT INTO TBLGiangVien VALUES
(11,'Thanh Binh',700,'Geo'),    
(12,'Thu Huong',500,'Math'),
(13,'Chu Vinh',650,'Geo'),
(14,'Le Thi Ly',500,'Bio'),
(15,'Tran Son',900,'Math');

INSERT INTO TBLSinhVien VALUES
(1,'Le Van Son','Bio',1990,'Nghe An'),
(2,'Nguyen Thi Mai','Geo',1990,'Thanh Hoa'),
(3,'Bui Xuan Duc','Math',1992,'Ha Noi'),
(4,'Nguyen Van Tung','Bio',null,'Ha Tinh'),
(5,'Le Khanh Linh','Bio',1989,'Ha Nam'),
(6,'Tran Khac Trong','Geo',1991,'Thanh Hoa'),
(7,'Le Thi Van','Math',null,'null'),
(8,'Hoang Van Duc','Bio',1992,'Nghe An');

INSERT INTO TBLDeTai VALUES
('Dt01','GIS',100,'Nghe An'),
('Dt02','ARC GIS',500,'Nam Dinh'),
('Dt03','Spatial DB',100, 'Ha Tinh'),
('Dt04','MAP',300,'Quang Binh' );

INSERT INTO TBLHuongDan VALUES
(1,'Dt01',13,8),
(2,'Dt03',14,0),
(3,'Dt03',12,10),
(5,'Dt04',14,7),
(6,'Dt01',13,Null),
(7,'Dt04',11,10),
(8,'Dt03',15,6);
--B. Chỉ sử dụng 01 lệnh SQL trả lời các yêu cầu sau:
--I.
--1.	Đưa ra thông tin gồm mã số, họ tênvà tên khoa của tất cả các giảng viên
select Magv,Hotengv,TBLKhoa.Tenkhoa
from TBLGiangVien,TBLKhoa 
where TBLGiangVien.Makhoa=TBLKhoa.Makhoa
--2.	Đưa ra thông tin gồm mã số, họ tên và tên khoa của các giảng viên của khoa ‘DIA LY va QLTN’
select Magv,Hotengv,TBLKhoa.Tenkhoa 
from TBLGiangVien,TBLKhoa 
where TBLGiangVien.Makhoa=TBLKhoa.Makhoa and Tenkhoa='DIA LY va QLTN'
--3.	Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’
select count(*) as 'Sinh Viên Khoa CNSH'
from TBLKhoa,TBLSinhVien 
where TBLSinhVien.Makhoa=TBLKhoa.Makhoa and Tenkhoa='CONG NGHE SINH HOC'
--4.	Đưa ra danh sách gồm mã số, họ tên và tuổi của các sinh viên khoa ‘TOAN’
select Masv,Hotensv,(YEAR(GETDATE())-Namsinh) as 'Tuoi' 
from TBLSinhVien,TBLKhoa 
where TBLSinhVien.Makhoa=TBLKhoa.Makhoa and Tenkhoa='TOAN'
--5.	Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’
select COUNT(*) as 'So gian vien' 
from TBLGiangVien,TBLKhoa 
where TBLGiangVien.Makhoa=TBLKhoa.Makhoa and Tenkhoa='CONG NGHE SINH HOC'
--6.	Cho biết thông tin về sinh viên không tham gia thực tập
select TBLSinhVien.* 
from TBLSinhVien,TBLHuongDan 
where TBLSinhVien.Masv=TBLHuongDan.Masv and KetQua is null
--7.	Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
select TBLKhoa.Makhoa,Tenkhoa, COUNT(TBLGiangVien.Magv) as 'So giang vien' 
from TBLKhoa,TBLGiangVien 
where TBLKhoa.Makhoa=TBLGiangVien.Makhoa 
group by TBLKhoa.Makhoa,Tenkhoa
--8.	Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học
select Dienthoai 
from TBLSinhVien,TBLKhoa 
where TBLSinhVien.Makhoa=TBLKhoa.Makhoa and Hotensv='Le van son'
--II
--1.	Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
select TBLDeTai.Madt,Tendt
from TBLGiangVien,TBLDeTai,TBLHuongDan 
where TBLGiangVien.Magv=TBLHuongDan.Magv and TBLHuongDan.Madt=TBLDeTai.Madt and Hotengv='Tran son' 
--2.	Cho biết tên đề tài không có sinh viên nào thực tập
select Tendt from TBLDeTai 
where TBLDeTai.Madt not in (select TBLHuongDan.Madt from TBLHuongDan)
--3.	Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
select TBLGiangVien.Magv,Hotengv,Tenkhoa from 
TBLKhoa,TBLGiangVien
where TBLGiangVien.Makhoa=TBLKhoa.Makhoa 
and TBLGiangVien.Magv in (select Magv from TBLHuongDan 
group by Magv
having count(Masv)>=3 )

--4.	Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
select Madt,Tendt 
from TBLDeTai
where Kinhphi=(select max(Kinhphi) from TBLDeTai)
--5.	Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
select Madt,Tendt from TBLDeTai where Madt in (select Madt from TBLHuongDan 
group by  Madt
having count(Masv)>2)

--6.	Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘DIALY và QLTN’
select TBLSinhVien.Masv,Hotensv,KetQua from TBLHuongDan,TBLKhoa,TBLSinhVien 
where TBLHuongDan.Masv=TBLSinhVien.Masv and TBLSinhVien.Makhoa=TBLKhoa.Makhoa and Tenkhoa='Dia ly va QLTN'
--7.	Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
select Tenkhoa,COUNT(TBLSinhVien.Makhoa) as 'So luong sinh Viên' from TBLKhoa,TBLSinhVien
where TBLKhoa.Makhoa=TBLSinhVien.Makhoa
group by Tenkhoa
--8.	Cho biết thông tin về các sinh viên thực tập tại quê nhà
select TBLSinhVien.* from TBLSinhVien,TBLDeTai,TBLHuongDan 
where TBLDeTai.Madt=TBLHuongDan.Madt and TBLHuongDan.Masv=TBLSinhVien.Masv and Quequan=Noithuctap
--9.	Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
select TBLSinhVien.* from TBLSinhVien,TBLHuongDan where TBLSinhVien.Masv=TBLHuongDan.Masv and KetQua is null
--10.	 Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
select Masv,Hotensv from TBLSinhVien where Masv in (select Masv from TBLHuongDan where KetQua=0)

