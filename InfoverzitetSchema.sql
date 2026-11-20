-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`registrovankorisnik`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`registrovankorisnik` (
  `idRegistrovanKorisnik` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(60) NOT NULL,
  `email` VARCHAR(60) NOT NULL,
  `password` VARCHAR(60) NOT NULL,
  `status` ENUM('aktivan', 'neaktivan', 'blokiran') NOT NULL DEFAULT 'aktivan',
  `is_verified` TINYINT NOT NULL DEFAULT '0',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idRegistrovanKorisnik`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`administrator`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`administrator` (
  `idRegistrovanKorisnik` INT NOT NULL,
  PRIMARY KEY (`idRegistrovanKorisnik`),
  CONSTRAINT `fk_Administrator_RegistrovanKorisnik`
    FOREIGN KEY (`idRegistrovanKorisnik`)
    REFERENCES `mydb`.`registrovankorisnik` (`idRegistrovanKorisnik`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`forum`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`forum` (
  `idForum` INT NOT NULL AUTO_INCREMENT,
  `naslov` VARCHAR(100) NOT NULL,
  `deskripcija` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`idForum`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`obicankorisnik`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`obicankorisnik` (
  `idRegistrovanKorisnik` INT NOT NULL,
  PRIMARY KEY (`idRegistrovanKorisnik`),
  CONSTRAINT `fk_ObicanKorisnik_RegistrovanKorisnik`
    FOREIGN KEY (`idRegistrovanKorisnik`)
    REFERENCES `mydb`.`registrovankorisnik` (`idRegistrovanKorisnik`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`student` (
  `idRegistrovanKorisnik` INT NOT NULL,
  `ime` VARCHAR(45) NOT NULL,
  `prezime` VARCHAR(45) NOT NULL,
  `grad_stanovanja` VARCHAR(45) NOT NULL,
  `fakultet` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRegistrovanKorisnik`),
  CONSTRAINT `fk_Student_ObicanKorisnik`
    FOREIGN KEY (`idRegistrovanKorisnik`)
    REFERENCES `mydb`.`obicankorisnik` (`idRegistrovanKorisnik`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`forumpost`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`forumpost` (
  `idForumPost` INT NOT NULL AUTO_INCREMENT,
  `idForum` INT NOT NULL,
  `idRegistrovanKorisnik` INT NOT NULL,
  `naslov` VARCHAR(100) NOT NULL,
  `teskt` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`idForumPost`, `idRegistrovanKorisnik`, `idForum`),
  INDEX `fk_ForumPost_Forum_idx` (`idForum` ASC) VISIBLE,
  INDEX `fk_ForumPost_Student_idx` (`idRegistrovanKorisnik` ASC) VISIBLE,
  CONSTRAINT `fk_ForumPost_Forum`
    FOREIGN KEY (`idForum`)
    REFERENCES `mydb`.`forum` (`idForum`),
  CONSTRAINT `fk_ForumPost_Student`
    FOREIGN KEY (`idRegistrovanKorisnik`)
    REFERENCES `mydb`.`student` (`idRegistrovanKorisnik`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`komentar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`komentar` (
  `idKomentar` INT NOT NULL AUTO_INCREMENT,
  `idRegistrovanKorisnik` INT NOT NULL,
  `idForumPost` INT NOT NULL,
  `tekst` VARCHAR(200) NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idKomentar`, `idRegistrovanKorisnik`, `idForumPost`),
  INDEX `fk_Komentar_Student_idx` (`idRegistrovanKorisnik` ASC) VISIBLE,
  INDEX `fk_Komentar_ForumPost_idx` (`idForumPost` ASC) VISIBLE,
  CONSTRAINT `fk_Komentar_ForumPost`
    FOREIGN KEY (`idForumPost`)
    REFERENCES `mydb`.`forumpost` (`idForumPost`),
  CONSTRAINT `fk_Komentar_Student`
    FOREIGN KEY (`idRegistrovanKorisnik`)
    REFERENCES `mydb`.`student` (`idRegistrovanKorisnik`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`poslovnikorisnik`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`poslovnikorisnik` (
  `idRegistrovanKorisnik` INT NOT NULL,
  `ime_kompanije` VARCHAR(120) NOT NULL,
  `adresa_kompanije` VARCHAR(120) NOT NULL,
  `JIB` VARCHAR(12) NOT NULL,
  `djelatnost` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`idRegistrovanKorisnik`),
  CONSTRAINT `fk_PoslovniKorisnik_ObicanKorisnik`
    FOREIGN KEY (`idRegistrovanKorisnik`)
    REFERENCES `mydb`.`obicankorisnik` (`idRegistrovanKorisnik`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`oglas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`oglas` (
  `idOglas` INT NOT NULL AUTO_INCREMENT,
  `idRegistrovanKorisnik` INT NOT NULL,
  `naslov` VARCHAR(100) NOT NULL,
  `tekst` VARCHAR(200) NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idOglas`, `idRegistrovanKorisnik`),
  INDEX `fk_Oglas_PoslovniKorisnik_idx` (`idRegistrovanKorisnik` ASC) VISIBLE,
  CONSTRAINT `fk_Oglas_PoslovniKorisnik`
    FOREIGN KEY (`idRegistrovanKorisnik`)
    REFERENCES `mydb`.`poslovnikorisnik` (`idRegistrovanKorisnik`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`razgovor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`razgovor` (
  `idRazgovor` INT NOT NULL AUTO_INCREMENT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idRazgovor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`poruka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`poruka` (
  `idPoruka` INT NOT NULL AUTO_INCREMENT,
  `idRegistrovanKorisnik` INT NOT NULL,
  `idRazgovor` INT NOT NULL,
  `tekst` VARCHAR(200) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idPoruka`, `idRegistrovanKorisnik`, `idRazgovor`),
  INDEX `fk_Poruka_ObicanKorisnik_idx` (`idRegistrovanKorisnik` ASC) VISIBLE,
  INDEX `fk_Poruka_Razgovor_idx` (`idRazgovor` ASC) VISIBLE,
  CONSTRAINT `fk_Poruka_ObicanKorisnik`
    FOREIGN KEY (`idRegistrovanKorisnik`)
    REFERENCES `mydb`.`obicankorisnik` (`idRegistrovanKorisnik`),
  CONSTRAINT `fk_Poruka_Razgovor`
    FOREIGN KEY (`idRazgovor`)
    REFERENCES `mydb`.`razgovor` (`idRazgovor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`raspored`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`raspored` (
  `idRaspored` INT NOT NULL AUTO_INCREMENT,
  `registrovankorisnik_idRegistrovanKorisnik` INT NOT NULL,
  `naziv` VARCHAR(100) NOT NULL,
  `vidljivost` ENUM('javan', 'privatan', 'link') NOT NULL,
  `opis` VARCHAR(200) NULL,
  `shareToken` VARCHAR(64) NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`idRaspored`, `registrovankorisnik_idRegistrovanKorisnik`),
  INDEX `fk_raspored_registrovankorisnik1_idx` (`registrovankorisnik_idRegistrovanKorisnik` ASC) VISIBLE,
  UNIQUE INDEX `shareToken_UNIQUE` (`shareToken` ASC) VISIBLE,
  CONSTRAINT `fk_raspored_registrovankorisnik1`
    FOREIGN KEY (`registrovankorisnik_idRegistrovanKorisnik`)
    REFERENCES `mydb`.`registrovankorisnik` (`idRegistrovanKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`timeblock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`timeblock` (
  `idTimeBlock` INT NOT NULL AUTO_INCREMENT,
  `idRaspored` INT NOT NULL,
  `start_time` TIMESTAMP NOT NULL,
  `end_time` TIMESTAMP NOT NULL,
  `naslov` VARCHAR(100) NOT NULL,
  `deksripcija` VARCHAR(200) NULL DEFAULT NULL,
  `char_boja` CHAR(7) NOT NULL,
  PRIMARY KEY (`idTimeBlock`, `idRaspored`),
  INDEX `fk_TimeBlock_Raspored_idx` (`idRaspored` ASC) VISIBLE,
  CONSTRAINT `fk_TimeBlock_Raspored`
    FOREIGN KEY (`idRaspored`)
    REFERENCES `mydb`.`raspored` (`idRaspored`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`ucesnikrazgovora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ucesnikrazgovora` (
  `idRegistrovanKorisnik` INT NOT NULL,
  `idRazgovor` INT NOT NULL,
  PRIMARY KEY (`idRegistrovanKorisnik`, `idRazgovor`),
  INDEX `fk_UcesnikRazgovora_Razgovor_idx` (`idRazgovor` ASC) VISIBLE,
  CONSTRAINT `fk_UcesnikRazgovora_ObicanKorisnik`
    FOREIGN KEY (`idRegistrovanKorisnik`)
    REFERENCES `mydb`.`obicankorisnik` (`idRegistrovanKorisnik`),
  CONSTRAINT `fk_UcesnikRazgovora_Razgovor`
    FOREIGN KEY (`idRazgovor`)
    REFERENCES `mydb`.`razgovor` (`idRazgovor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`registrovankorisnik_has_raspored`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`registrovankorisnik_has_raspored` (
  `registrovankorisnik_idRegistrovanKorisnik` INT NOT NULL,
  `raspored_idRaspored` INT NOT NULL,
  `raspored_registrovankorisnik_idRegistrovanKorisnik` INT NOT NULL,
  `dozvola` ENUM('pregled', 'izmena') NOT NULL DEFAULT 'pregled',
  `shared_at` DATETIME NOT NULL,
  INDEX `fk_registrovankorisnik_has_raspored_raspored1_idx` (`raspored_idRaspored` ASC, `raspored_registrovankorisnik_idRegistrovanKorisnik` ASC) VISIBLE,
  INDEX `fk_registrovankorisnik_has_raspored_registrovankorisnik1_idx` (`registrovankorisnik_idRegistrovanKorisnik` ASC) VISIBLE,
  PRIMARY KEY (`raspored_idRaspored`, `raspored_registrovankorisnik_idRegistrovanKorisnik`, `registrovankorisnik_idRegistrovanKorisnik`),
  CONSTRAINT `fk_registrovankorisnik_has_raspored_registrovankorisnik1`
    FOREIGN KEY (`registrovankorisnik_idRegistrovanKorisnik`)
    REFERENCES `mydb`.`registrovankorisnik` (`idRegistrovanKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registrovankorisnik_has_raspored_raspored1`
    FOREIGN KEY (`raspored_idRaspored` , `raspored_registrovankorisnik_idRegistrovanKorisnik`)
    REFERENCES `mydb`.`raspored` (`idRaspored` , `registrovankorisnik_idRegistrovanKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`Podsetnik`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Podsetnik` (
  `idPodsetnik` INT NOT NULL AUTO_INCREMENT,
  `student_idRegistrovanKorisnik` INT NOT NULL,
  `naziv` VARCHAR(100) NOT NULL,
  `opis` VARCHAR(200) NULL,
  `created_at` DATETIME NOT NULL,
  `expiration_date` DATETIME NOT NULL,
  `prioritet` ENUM('low', 'medium', 'high') NOT NULL DEFAULT 'low',
  `status` ENUM('active', 'expired') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`idPodsetnik`, `student_idRegistrovanKorisnik`),
  INDEX `fk_Podsetnik_student1_idx` (`student_idRegistrovanKorisnik` ASC) VISIBLE,
  CONSTRAINT `fk_Podsetnik_student1`
    FOREIGN KEY (`student_idRegistrovanKorisnik`)
    REFERENCES `mydb`.`student` (`idRegistrovanKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
