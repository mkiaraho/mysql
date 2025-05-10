create database CLINIC_BOOKING_SYSTEM;
-- Drop existing tables if any (for clean re-runs)
DROP TABLE IF EXISTS Appointment, Patient, Doctor, Service, Doctor_Service;

-- Create Patient Table
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    phone_number VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE
);

-- Create Doctor Table
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE
);

-- Create Service Table
CREATE TABLE Service (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    service_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL
);

-- Many-to-Many: Doctor can offer multiple services, and a service can be offered by multiple doctors
CREATE TABLE Doctor_Service (
    doctor_id INT,
    service_id INT,
    PRIMARY KEY (doctor_id, service_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Appointment Table
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    service_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- Insert Patients
INSERT INTO Patient (first_name, last_name, date_of_birth, gender, phone_number, email)
VALUES
('Jane', 'Doe', '1995-05-15', 'Female', '0712345678', 'jane.doe@example.com'),
('John', 'Smith', '1989-09-30', 'Male', '0798765432', 'john.smith@example.com');

-- Insert Doctors
INSERT INTO Doctor (first_name, last_name, specialty, phone_number, email)
VALUES
('Dr. Alice', 'Kamau', 'General Practitioner', '0700112233', 'alice.kamau@clinic.com'),
('Dr. Brian', 'Otieno', 'Dermatologist', '0723344556', 'brian.otieno@clinic.com');

-- Insert Services
INSERT INTO Service (service_name, description, price)
VALUES
('General Checkup', 'Basic health check and consultation.', 1500.00),
('Skin Consultation', 'Diagnosis and treatment of skin-related conditions.', 2500.00);

-- Map Doctors to Services
INSERT INTO Doctor_Service (doctor_id, service_id)
VALUES
(1, 1), -- Dr. Alice offers General Checkup
(2, 1), -- Dr. Brian also offers General Checkup
(2, 2); -- Dr. Brian offers Skin Consultation

-- Insert Appointments
INSERT INTO Appointment (patient_id, doctor_id, service_id, appointment_date, status, notes)
VALUES
(1, 1, 1, '2025-05-15 10:00:00', 'Scheduled', 'First-time visit.'),
(2, 2, 2, '2025-05-16 14:30:00', 'Scheduled', 'Recurring issue.');
SELECT a.appointment_id, 
       p.first_name AS patient_name, 
       d.first_name AS doctor_name, 
       s.service_name, 
       a.appointment_date, 
       a.status
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Doctor d ON a.doctor_id = d.doctor_id
JOIN Service s ON a.service_id = s.service_id;
SELECT d.first_name AS doctor_name, s.service_name
FROM Doctor_Service ds
JOIN Doctor d ON ds.doctor_id = d.doctor_id
JOIN Service s ON ds.service_id = s.service_id
ORDER BY doctor_name;
SELECT a.appointment_date, s.service_name, d.first_name AS doctor_name, a.status
FROM Appointment a
JOIN Service s ON a.service_id = s.service_id
JOIN Doctor d ON a.doctor_id = d.doctor_id
WHERE a.patient_id = 1;

