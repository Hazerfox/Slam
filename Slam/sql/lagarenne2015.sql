-- MySQL Workbench Forward Engineering

-- Penser à supprimer la ligne en dessous (DELIMITER $) si vous utilisez phpMyadmin et noter
-- $ en délimiteur en phpMyadmin en bas de la fenetre de code SQL

DELIMITER $

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0$
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0$
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES'$


-- -----------------------------------------------------
-- Schema lagarenne2015
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema lagarenne2015
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS lagarenne2015$
CREATE SCHEMA IF NOT EXISTS lagarenne2015 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci $
USE lagarenne2015 $

-- -----------------------------------------------------
-- Table personne
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS personne (
  id_personne INT NOT NULL AUTO_INCREMENT,
  civilite VARCHAR(3) NOT NULL,
  prenom VARCHAR(20) NOT NULL,
  nom VARCHAR(30) NOT NULL,
  adresse VARCHAR(45) NULL,
  code_postal VARCHAR(5) NULL,
  ville VARCHAR(30) NULL,
  telephone VARCHAR(15) NULL,
  telephone2 VARCHAR(15) NULL,
  email VARCHAR(30) NOT NULL,
  mot_passe VARCHAR(45) NOT NULL,
  date_inscription DATETIME NOT NULL,
  est_inscrite TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id_personne),
  UNIQUE INDEX email_UNIQUE (email ASC))
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table module
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS module (
  id_module INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(128) NOT NULL,
  objectif VARCHAR(512) NULL,
  contenu VARCHAR(45) NULL,
  nb_heures INT NULL,
  prerequis VARCHAR(512) NULL,
  PRIMARY KEY (id_module))
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table formation
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS formation (
  id_formation INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(45) NOT NULL,
  description TEXT NULL,
  PRIMARY KEY (id_formation))
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table session
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS session (
  id_session INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(45) NOT NULL,
  date_debut DATE NOT NULL,
  date_fin DATE NOT NULL,
  description TEXT NULL,
  id_formation INT NOT NULL,
  date_debut_inscription DATETIME NULL,
  date_fin_inscription DATETIME NULL,
  PRIMARY KEY (id_session),
  INDEX fk_session_formation_idx (id_formation ASC),
  CONSTRAINT fk_session_formation
    FOREIGN KEY (id_formation)
    REFERENCES formation (id_formation)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table formateur
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS formateur (
  id_personne INT NOT NULL,
  date_entree DATE NULL,
  PRIMARY KEY (id_personne),
  CONSTRAINT fk_formateur_personne1
    FOREIGN KEY (id_personne)
    REFERENCES personne (id_personne)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table evaluation
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS evaluation (
  id_evaluation INT NOT NULL AUTO_INCREMENT,
  id_module INT NOT NULL,
  id_session INT NOT NULL,
  id_formateur INT NOT NULL,
  PRIMARY KEY (id_evaluation),
  INDEX fk_evaluation_module1_idx (id_module ASC),
  INDEX fk_evaluation_session1_idx (id_session ASC),
  INDEX fk_evaluation_formateur1_idx (id_formateur ASC),
  CONSTRAINT fk_evaluation_module1
    FOREIGN KEY (id_module)
    REFERENCES module (id_module)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_evaluation_session1
    FOREIGN KEY (id_session)
    REFERENCES session (id_session)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_evaluation_formateur1
    FOREIGN KEY (id_formateur)
    REFERENCES formateur (id_personne)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table module_formation
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS module_formation (
  id_module INT NOT NULL,
  id_formation INT NOT NULL,
  PRIMARY KEY (id_module, id_formation),
  INDEX fk_module_has_formation_formation1_idx (id_formation ASC),
  INDEX fk_module_has_formation_module1_idx (id_module ASC),
  CONSTRAINT fk_module_has_formation_module1
    FOREIGN KEY (id_module)
    REFERENCES module (id_module)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_module_has_formation_formation1
    FOREIGN KEY (id_formation)
    REFERENCES formation (id_formation)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table etat_candidature
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS etat_candidature (
  id_etat_candidature CHAR(1) NOT NULL,
  libelle VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_etat_candidature))
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table candidature
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS candidature (
  id_session INT NOT NULL,
  id_personne INT NOT NULL,
  id_etat_candidature CHAR(1) NOT NULL,
  date_effet DATETIME NOT NULL,
  motivation TEXT NULL,
  PRIMARY KEY (id_session, id_personne),
  INDEX fk_session_has_personne_personne1_idx (id_personne ASC),
  INDEX fk_session_has_personne_session1_idx (id_session ASC),
  INDEX fk_candidature_etat_candidature1_idx (id_etat_candidature ASC),
  CONSTRAINT fk_session_has_personne_session1
    FOREIGN KEY (id_session)
    REFERENCES session (id_session)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_session_has_personne_personne1
    FOREIGN KEY (id_personne)
    REFERENCES personne (id_personne)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_candidature_etat_candidature1
    FOREIGN KEY (id_etat_candidature)
    REFERENCES etat_candidature (id_etat_candidature)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table salle
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS salle (
  id_salle INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_salle))
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table seance
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS seance (
  id_module INT NOT NULL,
  id_session INT NOT NULL,
  id_personne INT NOT NULL,
  debut DATETIME NOT NULL,
  fin DATETIME NOT NULL,
  id_salle INT NOT NULL,
  contenu TEXT NULL,
  PRIMARY KEY (id_module, id_session, id_personne, debut, fin, id_salle),
  INDEX fk_seance_session1_idx (id_session ASC),
  INDEX fk_seance_formateur1_idx (id_personne ASC),
  INDEX fk_seance_salle1_idx (id_salle ASC),
  CONSTRAINT fk_seance_module1
    FOREIGN KEY (id_module)
    REFERENCES module (id_module)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_seance_session1
    FOREIGN KEY (id_session)
    REFERENCES session (id_session)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_seance_formateur1
    FOREIGN KEY (id_personne)
    REFERENCES formateur (id_personne)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_seance_salle1
    FOREIGN KEY (id_salle)
    REFERENCES salle (id_salle)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table note
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS note (
  id_evaluation INT NOT NULL,
  id_personne INT NOT NULL,
  note DECIMAL(3,1) NOT NULL,
  PRIMARY KEY (id_evaluation, id_personne),
  INDEX fk_note_personne1_idx (id_personne ASC),
  CONSTRAINT fk_note_evaluation1
    FOREIGN KEY (id_evaluation)
    REFERENCES evaluation (id_evaluation)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_note_personne1
    FOREIGN KEY (id_personne)
    REFERENCES personne (id_personne)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table theme
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS theme (
  id_theme INT NOT NULL AUTO_INCREMENT,
  libelle VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_theme),
  UNIQUE INDEX libelle_UNIQUE (libelle ASC))
ENGINE = InnoDB$


-- -----------------------------------------------------
-- Table module_theme
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS module_theme (
  id_module INT NOT NULL,
  id_theme INT NOT NULL,
  PRIMARY KEY (id_module, id_theme),
  INDEX fk_module_theme_theme1_idx (id_theme ASC),
  INDEX fk_module_theme_module1_idx (id_module ASC),
  CONSTRAINT fk_module_theme_module1
    FOREIGN KEY (id_module)
    REFERENCES module (id_module)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_module_theme_theme1
    FOREIGN KEY (id_theme)
    REFERENCES theme (id_theme)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB$


SET SQL_MODE=@OLD_SQL_MODE$
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS$
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS$



-- Procedure stockée

DROP PROCEDURE IF EXISTS refresh_base$

CREATE DEFINER=root@localhost PROCEDURE refresh_base()
BEGIN
  START TRANSACTION;
  
  DELETE FROM seance;
  DELETE FROM note;
  DELETE FROM evaluation;
  DELETE FROM candidature;
  DELETE FROM etat_candidature;
  DELETE FROM salle;
  DELETE FROM session;
  DELETE FROM module_formation;
  DELETE FROM formation;
  DELETE FROM module_theme;
  DELETE FROM theme;
  DELETE FROM module;
  DELETE FROM formateur;
  DELETE FROM personne;
      
  INSERT INTO personne
  (id_personne,civilite,prenom, nom,adresse,code_postal,ville,telephone,telephone2,email,mot_passe,date_inscription,est_inscrite) VALUES
  (1, 'M.', 'Jérome', 'LE BARON', '33 Chemin du fossé de laumone', '92600', 'Asnières', '0951466417', null, 'lebaronjerome@free.fr', 'dopler', current_timestamp(), 0),
  (2, 'Mle', 'Emilie', 'WAILLE', '25 Avenue de la gare', '92000', 'NANTERRE', '0956789101', null, 'waille@hotmail.fr', 'walle', current_timestamp(), 0),
  (3, 'M.', 'Saad', 'Hassaini', '123 Rue de la mairie', '95230', 'POISSY', '0532198734', null, 'saadh@gmail.com', 'loljeu', current_timestamp(), 0),
  (4, 'Mme', 'Brigitte', 'GROLEAS', '12 Rue du temple', '95000', 'ARGENTEUIL', '0125897456', null, 'brigitte@groleas.fr', 'java8', current_timestamp(), 0),
  (5, 'M.', 'Michel', 'PLASSE', '5 Rue des martyrs', '78560', 'MELUN', '0244896531', null, 'm.plasse@voila.fr', 'tintin', current_timestamp(), 0),
  (6, 'Mme', 'Sylvie', 'JOUANNE', '52 Avenue de la république', '75012', 'PARIS', '0137548652', null, 'jsylvie.@orange.fr', 'proust', current_timestamp(), 0);

  INSERT INTO formateur
  (id_personne, date_entree) VALUES
  (4, '2008-01-09'),
  (5, '2009-09-15'),
  (6, '2012-05-02');

  INSERT INTO module
  (id_module, nom, objectif, contenu, nb_heures, prerequis) VALUES
  (1, 'SI2', 'Enseigner aux élèves les bases sur le fonctionnement du réseau internet', 'Des TP et des cours', 30, 'Les prérequis sont le module SI1 et le binaire'),
  (2, 'Maths', 'Enseigner aux élèves les notions de mathématiques nécessaires en informatique', 'Des cours théoriques et du python', 50, 'Les prérequis sont le BAC'),
  (3, 'Anglais', 'Enseigner la compréhension orale et de texte', 'Des cours et beaucoup de pratique orale', 50, 'Les prérequis sont le BAC et un peu d''attention');

  INSERT INTO theme
  (id_theme, libelle) VALUES
  (1, 'informatique'),
  (2, 'culture'),
  (3, 'langue');

  INSERT INTO module_theme
  (id_module, id_theme) VALUES
  (1, 1),
  (2, 2),
  (3, 3);

  INSERT INTO formation
  (id_formation, nom, description) VALUES
  (1, 'BTS SIO', 'Formation pour obtenie le BTS Services Informatiques aux Organisations options SISR ou SLAM'),
  (2, 'BTS CG', 'Formation pour obtenir le BTS Comptabilité et Gestion'),
  (3, 'BTS Audiovisuel', 'Formation pour obtenir le BTS Audiovisuel option Son, Image ou Montage');

  INSERT INTO module_formation
  (id_module, id_formation) VALUES
  (1, 1),
  (2, 2),
  (3, 3);

  INSERT INTO session
  (id_session, nom, date_debut, date_fin, description, id_formation, date_debut_inscription, date_fin_inscription) VALUES
  (1, 'BTS SIO 2016', '2015-05-07', '2016-05-12', '4ème session pour le BTS SIO', 1, '2015-03-07 09:00:00', '2015-04-07 18:00:00'),
  (2, 'BTS CG 2016', '2015-09-25', '2016-09-15', '2ème session pour le BTS CG', 2, '2015-07-25 09:00:00', '2015-08-25 18:00:00'),
  (3, 'BTS Audio 2016', '2015-11-15', '2016-11-05', '1ère session pour le BTS Audiovisuel option son', 2, '2015-09-15 09:00:00', '2015-10-25 18:00:00');

  INSERT INTO salle
  (id_salle, nom) VALUES
  (1, 'Salle 306'),
  (2, 'Salle 201'),
  (3, 'Salle 114');

  INSERT INTO etat_candidature
  (id_etat_candidature, libelle) VALUES
  (1, 'A'),
  (2, 'V'),
  (3, 'R');

  INSERT INTO candidature
  (id_session, id_personne, id_etat_candidature, date_effet, motivation) VALUES
  (3, 2, 2, '2015-03-15 10:00:00', 'Je suis extrement motivé pour accéder à cette formation d''informatique, un domaine qui me passionne.'),
  (1, 3, 1, '2015-08-10 14:00:00', 'Je suis extrement motivé pour accéder à cette formation.'),
  (2, 1, 3, '2015-08-10 14:00:00', 'Je suis très motivé et passioné et souhaite donc accéder à cette formation.');

  INSERT INTO evaluation
  (id_evaluation, id_module, id_session, id_formateur) VALUES
  (1, 1, 1, 4),
  (2, 2, 2, 5),
  (3, 3, 3, 6);

  INSERT INTO note
  (id_evaluation, id_personne, note) VALUES
  (1, 1, 12),
  (2, 2, 14),
  (3, 3, 9);

  INSERT INTO seance
  (id_module, id_session, id_personne, debut, fin, id_salle, contenu) VALUES
  (1, 1, 4, '2015-06-02 09:00:00', '2015-06-02 13:00:00', 1, 'Première séance de SI2 avec découverte du fonctionnement d''internet'),
  (2, 2, 5, '2015-07-02 13:00:00', '2015-07-02 16:00:00', 1, 'Suite du cours sur les matrices'),
  (3, 3, 6, '2015-09-12 13:00:00', '2015-09-12 17:00:00', 1, 'Révision des propositions relatives');

  COMMIT;

  ALTER TABLE evaluation AUTO_INCREMENT=1;
  ALTER TABLE etat_candidature AUTO_INCREMENT=1;
  ALTER TABLE salle AUTO_INCREMENT=1;
  ALTER TABLE session AUTO_INCREMENT=1;
  ALTER TABLE formation AUTO_INCREMENT=1;
  ALTER TABLE theme AUTO_INCREMENT=1;
  ALTER TABLE module AUTO_INCREMENT=1;
  ALTER TABLE personne AUTO_INCREMENT=1;

END$
CALL refresh_base()$