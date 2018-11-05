-- MySQL Script generated by MySQL Workbench
-- Sun Nov  4 23:07:53 2018
-- Model: Lock    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS
, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS
, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE
, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA
IF NOT EXISTS `mydb` DEFAULT CHARACTER
SET utf8 ;
USE `mydb`
;

-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
CREATE TABLE
IF NOT EXISTS `mydb`.`user`
(
  `iduser` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR
(45) CHARACTER
SET 'latin1'
NOT NULL,
  `lastname` VARCHAR
(45) CHARACTER
SET 'latin1'
NULL,
  `Password` VARCHAR
(100) NULL,
  PRIMARY KEY
(`iduser`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`RoomLocks`
-- -----------------------------------------------------
CREATE TABLE
IF NOT EXISTS `mydb`.`RoomLocks`
(
  `ID_RoomKey` INT UNSIGNED NOT NULL,
  `ID_Lock` INT UNSIGNED NOT NULL,
  PRIMARY KEY
(`ID_RoomKey`, `ID_Lock`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`lock`
-- -----------------------------------------------------
CREATE TABLE
IF NOT EXISTS `mydb`.`lock`
(
  `idlock` INT NOT NULL AUTO_INCREMENT,
  `key` VARCHAR
(32) NOT NULL,
  `room` VARCHAR
(20) NULL,
  `failed_counter` INT NOT NULL,
  PRIMARY KEY
(`idlock`),
  UNIQUE INDEX `key_UNIQUE`
(`key` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.``
-- -----------------------------------------------------
CREATE TABLE
IF NOT EXISTS `mydb`.``
(
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`lock_has_user`
-- -----------------------------------------------------
CREATE TABLE
IF NOT EXISTS `mydb`.`lock_has_user`
(
  `lock` INT NOT NULL,
  `user` INT NOT NULL,
  PRIMARY KEY
(`lock`, `user`),
  INDEX `fk_lock_has_user_user1_idx`
(`user` ASC),
  INDEX `fk_lock_has_user_lock_idx`
(`lock` ASC),
  CONSTRAINT `fk_lock_has_user_lock`
    FOREIGN KEY
(`lock`)
    REFERENCES `mydb`.`lock`
(`idlock`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION,
  CONSTRAINT `fk_lock_has_user_user1`
    FOREIGN KEY
(`user`)
    REFERENCES `mydb`.`user`
(`iduser`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`group`
-- -----------------------------------------------------
CREATE TABLE
IF NOT EXISTS `mydb`.`group`
(
  `idgroup` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR
(45) NULL,
  `desc` VARCHAR
(45) NULL,
  PRIMARY KEY
(`idgroup`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_has_group`
-- -----------------------------------------------------
CREATE TABLE
IF NOT EXISTS `mydb`.`user_has_group`
(
  `user` INT NOT NULL,
  `group` INT NOT NULL,
  PRIMARY KEY
(`user`, `group`),
  INDEX `fk_user_has_group_group1_idx`
(`group` ASC),
  INDEX `fk_user_has_group_user1_idx`
(`user` ASC),
  CONSTRAINT `fk_user_has_group_user1`
    FOREIGN KEY
(`user`)
    REFERENCES `mydb`.`user`
(`iduser`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_group_group1`
    FOREIGN KEY
(`group`)
    REFERENCES `mydb`.`group`
(`idgroup`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`lock_has_group`
-- -----------------------------------------------------
CREATE TABLE
IF NOT EXISTS `mydb`.`lock_has_group`
(
  `lock` INT NOT NULL,
  `group` INT NOT NULL,
  PRIMARY KEY
(`lock`, `group`),
  INDEX `fk_group_has_lock_lock1_idx`
(`lock` ASC),
  INDEX `fk_group_has_lock_group1_idx`
(`group` ASC),
  CONSTRAINT `fk_group_has_lock_group1`
    FOREIGN KEY
(`group`)
    REFERENCES `mydb`.`group`
(`idgroup`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION,
  CONSTRAINT `fk_group_has_lock_lock1`
    FOREIGN KEY
(`lock`)
    REFERENCES `mydb`.`lock`
(`idlock`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE
=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS
=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS
=@OLD_UNIQUE_CHECKS;