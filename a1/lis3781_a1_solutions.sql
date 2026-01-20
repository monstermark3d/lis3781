-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mtrombly
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mtrombly` ;

-- -----------------------------------------------------
-- Schema mtrombly
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mtrombly` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `mtrombly` ;

-- -----------------------------------------------------
-- Table `mtrombly`.`job`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mtrombly`.`job` (
  `job_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `job_title` VARCHAR(45) NOT NULL,
  `job_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`job_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mtrombly`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mtrombly`.`employee` (
  `emp_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `job_id` TINYINT UNSIGNED NOT NULL,
  `emp_ssn` CHAR(9) NOT NULL,
  `emp_fname` VARCHAR(15) NOT NULL,
  `emp_lname` VARCHAR(30) NOT NULL,
  `emp_dob` DATE NOT NULL,
  `emp_start_date` DATE NOT NULL,
  `emp_end_date` DATE NULL,
  `emp_salary` DECIMAL(8,2) NOT NULL,
  `emp_street` VARCHAR(30) NOT NULL,
  `emp_city` VARCHAR(20) NOT NULL,
  `emp_state` CHAR(2) NOT NULL,
  `emp_zip` CHAR(9) NOT NULL,
  `emp_phone` BIGINT UNSIGNED NOT NULL,
  `emp_email` VARCHAR(100) NOT NULL,
  `emp_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`emp_id`),
  INDEX `fk_employee_job1_idx` (`job_id` ASC) VISIBLE,
  UNIQUE INDEX `emp_ssn_UNIQUE` (`emp_ssn` ASC) VISIBLE,
  CONSTRAINT `fk_employee_job1`
    FOREIGN KEY (`job_id`)
    REFERENCES `mtrombly`.`job` (`job_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mtrombly`.`dependent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mtrombly`.`dependent` (
  `dep_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` SMALLINT UNSIGNED NOT NULL,
  `dep_added` DATE NOT NULL,
  `dep_ssn` CHAR(9) NOT NULL,
  `dep_fname` VARCHAR(15) NOT NULL,
  `dep_lname` VARCHAR(30) NOT NULL,
  `dep_dob` DATE NOT NULL,
  `dep_relation` VARCHAR(20) NOT NULL,
  `dep_street` VARCHAR(30) NOT NULL,
  `dep_city` VARCHAR(20) NOT NULL,
  `dep_state` CHAR(2) NOT NULL,
  `dep_zip` CHAR(9) NOT NULL,
  `dep_phone` BIGINT UNSIGNED NOT NULL,
  `dep_email` VARCHAR(100) NULL,
  `dep_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`dep_id`),
  INDEX `fk_dependent_employee_idx` (`emp_id` ASC) VISIBLE,
  UNIQUE INDEX `dep_ssn_UNIQUE` (`dep_ssn` ASC) VISIBLE,
  CONSTRAINT `fk_dependent_employee`
    FOREIGN KEY (`emp_id`)
    REFERENCES `mtrombly`.`employee` (`emp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mtrombly`.`benefit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mtrombly`.`benefit` (
  `ben_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ben_name` VARCHAR(45) NOT NULL,
  `ben_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`ben_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mtrombly`.`pln_id`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mtrombly`.`pln_id` (
  `pln_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` SMALLINT UNSIGNED NOT NULL,
  `ben_id` TINYINT UNSIGNED NOT NULL,
  `pln_type` ENUM('single', 'spouse', 'family') NOT NULL,
  `pln_cost` DECIMAL(6,2) UNSIGNED NOT NULL,
  `pln_election_date` DATE NOT NULL,
  `pin_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`pln_id`),
  INDEX `fk_pln_id_employee1_idx` (`emp_id` ASC) VISIBLE,
  INDEX `fk_pln_id_befefit1_idx` (`ben_id` ASC) VISIBLE,
  CONSTRAINT `fk_pln_id_employee1`
    FOREIGN KEY (`emp_id`)
    REFERENCES `mtrombly`.`employee` (`emp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pln_id_befefit1`
    FOREIGN KEY (`ben_id`)
    REFERENCES `mtrombly`.`benefit` (`ben_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mtrombly`.`emp_hist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mtrombly`.`emp_hist` (
  `eht_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` SMALLINT UNSIGNED NULL,
  `eht_date` DATETIME NOT NULL DEFAULT current_timestamp,
  `eht_type` ENUM('i', 'u', 'd') NOT NULL DEFAULT 'i',
  `eht_job_id` TINYINT UNSIGNED NOT NULL,
  `eht_emp_salary` DECIMAL(8,2) NOT NULL,
  `eht_usr_changed` VARCHAR(30) NOT NULL,
  `eht_reason` VARCHAR(45) NOT NULL,
  `eht_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`eht_id`),
  INDEX `fk_emp_hist_employee1_idx` (`emp_id` ASC) VISIBLE,
  CONSTRAINT `fk_emp_hist_employee1`
    FOREIGN KEY (`emp_id`)
    REFERENCES `mtrombly`.`employee` (`emp_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `mtrombly`.`job`
-- -----------------------------------------------------
START TRANSACTION;
USE `mtrombly`;
INSERT INTO `mtrombly`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'Secretary', NULL);
INSERT INTO `mtrombly`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'Service Tech', NULL);
INSERT INTO `mtrombly`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'Manager', NULL);
INSERT INTO `mtrombly`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'Cashier', NULL);
INSERT INTO `mtrombly`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'Stock', NULL);
INSERT INTO `mtrombly`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'CEO', NULL);
INSERT INTO `mtrombly`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'Janitor', NULL);
INSERT INTO `mtrombly`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'Security', NULL);
INSERT INTO `mtrombly`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'IT', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mtrombly`.`employee`
-- -----------------------------------------------------
START TRANSACTION;
USE `mtrombly`;
INSERT INTO `mtrombly`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 4, '000223333', 'Marsha', 'Fromm', '1978-03-09', '2003-05-16', '2011-05-16', 72000, '123 Elm St.', 'Chicago', 'IL', '000031567', 5618742244, 'marshab@gmail.com', NULL);
INSERT INTO `mtrombly`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 2, '222114444', 'Steve', 'Crenshaw', '1952-07-3', '1980-09-11', NULL, 60000, '3789 Golf View', 'Phoenix', 'AZ', '850069191', 4077829908, 'stevecr@aol.com', NULL);
INSERT INTO `mtrombly`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 2, '001762345', 'Kathy', 'Camerie', '1985-10-24', '2006-09-16', NULL, 70000, '555 W Main St.', 'Anchorage', 'AK', '005036341', 2028765309, 'kathyca@microsoft.com', NULL);
INSERT INTO `mtrombly`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 3, '876431765', 'Robert', 'Laurie', '1975-06-15', '1998-01-03', NULL, 85000, '12 NW 15 Ave.', 'Panama City Beach', 'FL', '000067598', 2127639228, 'robertl2001@yahoo.com', NULL);
INSERT INTO `mtrombly`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 1, '000094562', 'Kelsey', 'Hawks', '1990-11-05', '2010-02-18', '2010-12-31', 65000, '6571 NE 20 Terr.', 'New York', 'NY', '000451892', 9042227638, 'kelseyhawk@gmail.com', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mtrombly`.`dependent`
-- -----------------------------------------------------
START TRANSACTION;
USE `mtrombly`;
INSERT INTO `mtrombly`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 1, '2003-05-18', '421557890', 'Billy', 'Bob', '1964-12-14', 'husband', '15789 Oak Ave', 'Lake City', 'FL', '35687', 8501234567, 'bbob@aol.com', 'test bob note');
INSERT INTO `mtrombly`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 3, '2006-10-20', '557890412', 'Bobby', 'Sue', '1990-10-28', 'daughter', '531 Hounds Tooth Lane', 'San Pedro', 'CA', '900192856', 8185382916, 'bsue@fsu.edu', 'test sue note');
INSERT INTO `mtrombly`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 2, '1982-06-29', '598116542', 'Marilyn', 'Monroe', '1926-05-31', 'granmother', '5916 Velcro Rd', 'Larame', 'WY', '732169240', 7178515798, 'mmonroe@hotmail.com', 'test grandma');
INSERT INTO `mtrombly`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 2, '2010-02-18', '823751842', 'Stephen', 'Banks', '2002-03-19', 'son', '8189 Estiva Ave', 'Stkie', 'IL', '417892653', 6164238257, 'sbanks@gmai.com', 'test banks note');
INSERT INTO `mtrombly`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 4, '1999-05-19', '247816834', 'Krista', 'King', '2005-08-02', 'niece', '91584 Seasame Blvd', 'Muskegan', 'MI', '496713486', 3137564829, 'kking@knology.net', 'test krista note');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mtrombly`.`benefit`
-- -----------------------------------------------------
START TRANSACTION;
USE `mtrombly`;
INSERT INTO `mtrombly`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, 'medical', NULL);
INSERT INTO `mtrombly`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, 'dental', NULL);
INSERT INTO `mtrombly`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, 'long-term disability', NULL);
INSERT INTO `mtrombly`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, '401k', NULL);
INSERT INTO `mtrombly`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, 'term life insurance', NULL);
INSERT INTO `mtrombly`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, 'vision', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mtrombly`.`pln_id`
-- -----------------------------------------------------
START TRANSACTION;
USE `mtrombly`;
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 1, 2, 'single', 500, '2013-01-01', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 2, 3, 'spouse', 1000, '2012-05-01', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 3, 4, 'family', 1500, '2011-06-01', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 5, 1, 'single', 220, '2014-05-05', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 4, 5, 'spouse', 600, '2013-11-01', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 1, 3, 'family', 1800, '2014-02-01', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 2, 4, 'single', 700, '2013-09-11', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 3, 5, 'spouse', 800, '2014-04-04', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 4, 2, 'family', 1300, '2011-08-01', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 5, 5, 'single', 690, '2012-12-01', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 1, 5, 'spouse', 900, '2013-10-05', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 2, 6, 'family', 2000, '2014-07-01', NULL);
INSERT INTO `mtrombly`.`pln_id` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pin_notes`) VALUES (DEFAULT, 3, 6, 'single', 550, '2014-03-15', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mtrombly`.`emp_hist`
-- -----------------------------------------------------
START TRANSACTION;
USE `mtrombly`;
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 1, '2001-03-19 09:30:00', 'i', 1, 50000, 'test', 'promotion', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 2, '2003-05-10 10:45:00', 'u', 2, 60000, 'test', 'demotion', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 3, '2005-07-18 12:00:00', 'i', 5, 70000, 'test', 'promotion', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 4, '2009-11-11 14:30:00', 'u', 3, 80000, 'test', 'dept. change', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 5, '2010-02-27 15:40:00', 'i', 4, 90000, 'test', 'job change', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 1, '2007-08-03 16:00:00', 'i', 9, 75000, 'test', 'job change', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 2, '2013-10-31 05:30:00', 'u', 8, 55000, 'test', 'years in serviced', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 3, '2004-07-30 04:00:00', 'i', 2, 45000, 'test', 'dept. change', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 4, '2015-01-01 00:00:00', 'i', 7, 85000, 'test', 'promotion', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 5, '2011-08-31 09:00:00', 'u', 1, 65000, 'test', 'years in service', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 1, '2016-04-30 08:30:00', 'i', 6, 450000, 'test', 'became CEO', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 1, '2017-05-19 11:00:00', 'u', 9, 35000, 'test', 'dropped plan', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 2, '2016-12-24 08:45:00', 'i', 8, 80000, 'test', 'job change', NULL);
INSERT INTO `mtrombly`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht_notes`) VALUES (DEFAULT, 3, DEFAULT, 'i', 7, 57000, 'test', 'new plan', 'current_timestamp example');

COMMIT;

