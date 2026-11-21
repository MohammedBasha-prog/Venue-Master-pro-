-- ==========================================================
-- 1. ÃœÊ· «·√œÊ«— (Roles)
-- ==========================================================
SET IDENTITY_INSERT Roles ON;
GO
INSERT INTO Roles (RoleID, RoleName, Description, IsActive) VALUES 
(1, 'Admin', '„œÌ— «·‰Ÿ«„ - ’·«ÕÌ«  ﬂ«„·… ⁄·Ï ﬂ«›… √ﬁ”«„ ÊﬁÊ«⁄œ «·»Ì«‰« ', 1),
(2, 'Accountant', '„Õ«”» - ≈œ«—… «·Õ”«»« ° «·”‰œ« ° «·œ›⁄« ° Ê«· ﬁ«—Ì— «·„«·Ì…', 1),
(3, 'Receptionist', '„”ƒÊ· «·«” ﬁ»«· Ê«·ÕÃÊ“«  - ≈œ«—… «·ÕÃÊ“«  Ê«·⁄„·«¡', 1);
GO
SET IDENTITY_INSERT Roles OFF;
GO

-- ==========================================================
-- 2. ÃœÊ· «·’·«ÕÌ«  «· ›’Ì·Ì… (Permissions)
-- ==========================================================
SET IDENTITY_INSERT Permissions ON;
GO
INSERT INTO Permissions (PermissionID, PermissionName, PermissionCode, Description, IsActive) VALUES 
(1, '≈÷«›… ÕÃ“ ÃœÌœ', 'BOOKINGS_ADD', ' ”„Õ ··„” Œœ„ »≈‰‘«¡ Ê À»Ì  ÕÃ“ ÃœÌœ ··ﬁ«⁄…', 1),
(2, ' ⁄œÌ· «·ÕÃÊ“« ', 'BOOKINGS_EDIT', ' ”„Õ » ⁄œÌ· »Ì«‰«  «·ÕÃÊ“«  «·ﬁ«∆„…', 1),
(3, '≈·€«¡ «·ÕÃÊ“« ', 'BOOKINGS_CANCEL', ' ”„Õ »≈·€«¡ «·ÕÃÊ“«  «·„”Ã·…', 1),
(4, '≈œ«—… «·⁄„·«¡', 'CUSTOMERS_MANAGE', '≈÷«›… Ê ⁄œÌ· »Ì«‰«  «·⁄„·«¡ Ê«·»ÕÀ ⁄‰Â„', 1),
(5, 'ﬁ»÷ «·œ›⁄«  «·„«·Ì…', 'PAYMENTS_RECEIVE', ' ”ÃÌ· ”‰œ«  «·ﬁ»÷ Ê«·⁄—»Ê‰« ', 1),
(6, '≈œ«—… «·„ÊŸ›Ì‰ Ê«·—Ê« »', 'EMPLOYEES_MANAGE', '≈œ«—… »Ì«‰«  «·„ÊŸ›Ì‰ Ê«·Õ—ﬂ«  «·„«·Ì…', 1),
(7, '⁄—÷ «· ﬁ«—Ì— «·„«·Ì…', 'REPORTS_VIEW', '«·«ÿ·«⁄ ⁄·Ï «·√—»«Õ° «·œŒ·° Ê«· ﬁ«—Ì— «·⁄«„…', 1);
GO
SET IDENTITY_INSERT Permissions OFF;
GO

-- ==========================================================
-- 3. ÃœÊ· —»ÿ «·√œÊ«— »«·’·«ÕÌ«  (RolePermissions)
-- ==========================================================
INSERT INTO RolePermissions (RoleID, PermissionID) VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7),
(2, 1), (2, 2), (2, 4), (2, 5), (2, 7),
(3, 1), (3, 2), (3, 4);
GO

-- ==========================================================
-- 4. ÃœÊ· «·„ÊŸ›Ê‰ Ê«·⁄„«· (Employees)
-- ==========================================================
SET IDENTITY_INSERT Employees ON;
GO
INSERT INTO Employees (EmployeeID, FirstName, SecondName, ThirdName, LastName, JobTitle, Department, Phone, BaseSalary, HireDate, IsActive) VALUES 
(1, 'Mohammed', 'Ahmed', 'Ali', 'Al-basha', '„œÌ— «·‰Ÿ«„', '«·≈œ«—… «·⁄·Ì«', '777123456', 1200.00, '2025-01-01', 1),
(2, 'Abdullah', 'Saleh', 'Mohammed', 'Al-basha', '„Õ«”» √Ê·', '«·ﬁ”„ «·„«·Ì', '733987654', 800.00, '2025-02-15', 1),
(3, 'Ibrahim', 'Hassan', 'Qassim', 'Al-bahsa', '„”ƒÊ· «” ﬁ»«·', '«· ‘€Ì·', '711555444', 600.00, '2025-03-10', 1);
GO
SET IDENTITY_INSERT Employees OFF;
GO

-- ==========================================================
-- 5. ÃœÊ· «·„” Œœ„Ì‰ (Users)
-- ==========================================================
SET IDENTITY_INSERT Users ON;
GO
INSERT INTO Users (UserID, EmployeeID, Username, PasswordHash, RoleID, IsActive) VALUES 
(1, 1, 'admin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c9c', 1, 1),
(2, 2, 'accountant', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c9c', 2, 1),
(3, 3, 'reception', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c9c', 3, 1);
GO
SET IDENTITY_INSERT Users OFF;
GO

-- ==========================================================
-- 6. ÃœÊ· «·⁄„·«¡ (Customers)
-- ==========================================================
SET IDENTITY_INSERT Customers ON;
GO
INSERT INTO Customers (CustomerID, FirstName, SecondName, ThirdName, LastName, IdentityNumber, Phone, Address) VALUES 
(1, 'Ahmed', 'Nasser', 'Mohammed', 'Al-Omari', '01020304050', '771112233', '’⁄Ê«‰ - ’‰⁄«¡'),
(2, 'Sultan', 'Abdulaziz', 'Ali', 'Al-Dais', '09080706050', '733445566', 'Õœ… - ’‰⁄«¡');
GO
SET IDENTITY_INSERT Customers OFF;
GO

-- ==========================================================
-- 7. ÃœÊ· «·ﬁ«⁄«  (Halls)
-- ==========================================================
SET IDENTITY_INSERT Halls ON;
GO
INSERT INTO Halls (HallID, HallName, Capacity, DefaultHourlyRate, IsActive, Description) VALUES 
(1, 'ﬁ«⁄… «·”»⁄Ì‰ «·ﬂ»—Ï', 500, 150.00, 1, 'ﬁ«⁄… „ÃÂ“… »«·ﬂ«„· ··√⁄—«” Ê«·„ƒ „—«  «·ﬂ»—Ï'),
(2, 'ﬁ«⁄… «·√“· «·„·ﬂÌ…', 300, 100.00, 1, 'ﬁ«⁄… ›Œ„… Ê„„Ì“… ··ŒÿÊ»… Ê«·„‰«”»«  «·„ Ê”ÿ…');
GO
SET IDENTITY_INSERT Halls OFF;
GO

-- ==========================================================
-- 8. ÃœÊ· √‰Ê«⁄ «·„‰«”»«  (EventTypes)
-- ==========================================
SET IDENTITY_INSERT EventTypes ON;
GO
INSERT INTO EventTypes (EventTypeID, TypeName, Description) VALUES 
(1, 'Õ›· “›«›', 'Õ›· “Ê«Ã —”„Ì'),
(2, 'Õ›· ŒÿÊ»…', 'Õ›· ≈⁄·«‰ ŒÿÊ»…'),
(3, '„ƒ „— / ‰œÊ« ', '›⁄«·Ì«  ‘—ﬂ«  Ê«Ã „«⁄«  —”„Ì…Ì…'),
(4, 'Õ›·  Œ—Ã', '«Õ ›«·«   Œ—Ã «·ÿ·«» Ê«·Ã«„⁄« ');
GO
SET IDENTITY_INSERT EventTypes OFF;
GO

-- ==========================================================
-- 9. ÃœÊ· Õ«·«  «·ÕÃ“ (BookingStatuses)
-- ==========================================
SET IDENTITY_INSERT BookingStatuses ON;
GO
INSERT INTO BookingStatuses (StatusID, StatusName, Description) VALUES 
(1, '„»œ∆Ì', ' „ ÕÃ“ «·„Ê⁄œ „ƒﬁ « »«‰ Ÿ«— œ›⁄ «·⁄—»Ê‰'),
(2, '„ƒﬂœ', ' „ œ›⁄ «·⁄—»Ê‰ Ê √ﬂÌœ «·ÕÃ“ —”„Ì«'),
(3, '„ﬂ „·', ' „ ≈ﬁ«„… «·Õ›· Ê ”ÊÌ… «·Õ”«»«  ‰Â«∆Ì«'),
(4, '„·€Ì', ' „ ≈·€«¡ «·ÕÃ“ „‰ ﬁ»· «·⁄„Ì· √Ê «·≈œ«—…');
GO
SET IDENTITY_INSERT BookingStatuses OFF;
GO

-- ==========================================================
-- 10. ÃœÊ· √‰„«ÿ «·›—‘ Ê«· ‰”Ìﬁ (DecorationStyles)
-- ==========================================
SET IDENTITY_INSERT DecorationStyles ON;
GO
INSERT INTO DecorationStyles (DecorationStyleID, StyleName, DefaultPrice, Description) VALUES 
(1, '›—‘ „·ﬂÌ ›«Œ—', 300.00, 'ﬂÊ‘… „Êœ—‰ „⁄ „›«—‘ –Â»Ì…'),
(2, '›—‘  ﬁ·ÌœÌ Ì„‰Ì', 200.00, '„œ«ﬂÌ Ê„”«‰œ  ﬁ·ÌœÌ… „⁄  ‰”Ìﬁ  —«ÀÌ'),
(3, '›—‘ »”Ìÿ (ﬂ·«”Ìﬂ)', 100.00, ' ‰”Ìﬁ Â«œ∆ Ê»”Ìÿ');
GO
SET IDENTITY_INSERT DecorationStyles OFF;
GO

-- ==========================================================
-- 11. ÃœÊ· «·√’Ê· Ê«· ÃÂÌ“«  (Assets)
-- ==========================================
SET IDENTITY_INSERT Assets ON;
GO
INSERT INTO Assets (AssetID, AssetName, TotalQuantity, Notes) VALUES 
(1, 'ﬂ—”Ì »·«” Ìﬂ ›Œ„', 600, '»Õ«·… „„ «“…'),
(2, 'ÿ«Ê·… œ«∆—Ì… ··÷ÌÊ›', 70, '„⁄ „›«—‘ »Ì÷«¡'),
(3, '„ﬂ»—«  ’Ê Ì… √”«”Ì…', 4, '„÷Œ„«  ’Ê Ì… „⁄ «·„«Ìﬂ« ');
GO
SET IDENTITY_INSERT Assets OFF;
GO

-- ==========================================================
-- 12. ÃœÊ· «·Œœ„«  «·≈÷«›Ì… (Services)
-- ==========================================
SET IDENTITY_INSERT Services ON;
GO
INSERT INTO Services (ServiceID, ServiceName, DefaultPrice) VALUES 
(1, 'Œœ„… «·÷Ì«›… Ê«·ﬁÂÊ…', 150.00),
(2, 'œÌ ÃÌ (DJ) Ê≈÷«¡«  ·Ì“—', 200.00),
(3, ' ’ÊÌ— ›Ê Ê€—«›Ì Ê›ÌœÌÊ «Õ —«›Ì', 250.00);
GO
SET IDENTITY_INSERT Services OFF;
GO

-- ==========================================================
-- 13. ÃœÊ· √‰Ê«⁄ «·œ›⁄«  «·„«·Ì… (PaymentTypes)
-- ==========================================
SET IDENTITY_INSERT PaymentTypes ON;
GO
INSERT INTO PaymentTypes (PaymentTypeID, PaymentTypeName, Description) VALUES 
(1, '⁄—»Ê‰ („ﬁœ„ ÕÃ“)', '«·„»·€ «·„œ›Ê⁄ · À»Ì  «·ÕÃ“ √Ê· „—…'),
(2, 'œ›⁄… ≈ﬂ„«· «·Õ”«»', '«·„»·€ «·„ »ﬁÌ · ”ÊÌ… ﬁÌ„… «·ÕÃ“ «·ﬂ«„·…'),
(3, ' √„Ì‰ ‰ﬁœÌ', '„»·€ «· √„Ì‰ «·„” —œ ÷œ «· ·›Ì« '),
(4, ' ⁄ÊÌ÷  ·›Ì« ', '€—«„… Œ’„ „‰ «· √„Ì‰ „ﬁ«»·  ·› √’Ê·');
GO
SET IDENTITY_INSERT PaymentTypes OFF;
GO

-- ==========================================================
-- 14. ÃœÊ· ÿ—ﬁ «·œ›⁄ (PaymentMethods)
-- ==========================================
SET IDENTITY_INSERT PaymentMethods ON;
GO
INSERT INTO PaymentMethods (PaymentMethodID, PaymentMethodName, Description) VALUES 
(1, '‰ﬁœ« (ﬂ«‘)', '«·œ›⁄ «·›Ê—Ì »«·⁄„·… «·‰ﬁœÌ… «·ÌœÊÌ…'),
(2, ' ÕÊÌ· »‰ﬂÌ / ’—«›…', '⁄»— ‘»ﬂ«  «·ÕÊ«·«  «·„Õ·Ì… √Ê «·Õ”«»«  «·»‰ﬂÌ…');
GO
SET IDENTITY_INSERT PaymentMethods OFF;
GO


