DROP SCHEMA IF EXISTS Airlines;
CREATE SCHEMA Airlines;
USE Airlines;
/*DROP TABLE IF EXISTS Anagrafiche;
DROP TABLE IF EXISTS Utenti;
DROP TABLE IF EXISTS Dipendenti;
DROP TABLE IF EXISTS Aerei;
DROP TABLE IF EXISTS Luoghi;
DROP TABLE IF EXISTS Aeroporti;
DROP TABLE IF EXISTS Compagnie;
DROP TABLE IF EXISTS Bagagli;
DROP TABLE IF EXISTS TariffeBagagli;
DROP TABLE IF EXISTS Tratte;
DROP TABLE IF EXISTS Voli;
DROP TABLE IF EXISTS Viaggi;
DROP TABLE IF EXISTS Scali;
DROP TABLE IF EXISTS Offerte;
DROP TABLE IF EXISTS Assistenze;
DROP TABLE IF EXISTS Posti;
DROP TABLE IF EXISTS Prenotazioni;
DROP TABLE IF EXISTS Itinerario;
*/

SET FOREIGN_KEY_CHECKS = 0;

/* Crea la tabella Anagrafiche */

CREATE TABLE Anagrafiche (
	idAnag		INT AUTO_INCREMENT PRIMARY KEY,
	nome		VARCHAR(15) NOT NULL,
	cognome		VARCHAR(15) NOT NULL,
	nascita		DATE NOT NULL,
	sesso		ENUM('M','F') DEFAULT "M",
	email		VARCHAR(25),
	UNIQUE (email)
) ENGINE=InnoDB;

/* Crea la tabella Utenti */

CREATE TABLE Utenti (
	idAnag		INT PRIMARY KEY,
	password	VARCHAR(40) NOT NULL,
	type         ENUM('Guest','Admin') DEFAULT "Guest",
	FOREIGN KEY (idAnag) 	REFERENCES Anagrafiche (idAnag)
				ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

/* Crea la tabella Dipendenti */

CREATE TABLE Dipendenti (
	   idAnag		INT PRIMARY KEY,
	   matricola	INT(10),
	   grado		ENUM('assistente','comandante','vice'),
	   idCompagnia	INT NOT NULL,	
	   UNIQUE (matricola),
	   FOREIGN KEY (idAnag) REFERENCES Anagrafiche (idAnag)
				ON UPDATE CASCADE,
	   FOREIGN KEY (idCompagnia)	REFERENCES Compagnie (idCompagnia)
					ON UPDATE CASCADE
) ENGINE=InnoDB;

/* Crea la tabella Aerei */

CREATE TABLE Aerei (
	matricola	VARCHAR(10) PRIMARY KEY,
	marca		VARCHAR(10),
	modello		VARCHAR(25),
	anno			YEAR,
	postiPrima	INT(3),
	postiSeconda	INT(3),
	idCompagnia	INT NOT NULL,
	FOREIGN KEY (idCompagnia) REFERENCES Compagnie (idCompagnia)
				  ON UPDATE CASCADE
) ENGINE=InnoDB;

/* Crea la tabella Luoghi */

CREATE TABLE Luoghi (
	idLuogo			INT AUTO_INCREMENT PRIMARY KEY,
	nomecitta	VARCHAR(15) NOT NULL,
	nazione		VARCHAR(15)
) ENGINE=InnoDB;

/* Crea la tabella Aeroporti */

CREATE TABLE Aeroporti (
	idAeroporto	INT AUTO_INCREMENT PRIMARY KEY,
	nome	     VARCHAR(15) NOT NULL,
	idLuogo		INT NOT NULL,
	FOREIGN KEY (idLuogo)	REFERENCES Luoghi (idLuogo)
				ON UPDATE CASCADE
) ENGINE=InnoDB;

/* Crea la tabella Compagnia */

CREATE TABLE Compagnie (
	idCompagnia	INT AUTO_INCREMENT PRIMARY KEY,
	nome		VARCHAR(100),
	numTel		VARCHAR(25),
	email		VARCHAR(50),
	nazione		VARCHAR(50)
)ENGINE=InnoDB;

/* Crea la tabella Bagaglio */

CREATE TABLE Bagagli(
	idBagaglio	INT AUTO_INCREMENT PRIMARY KEY,
	peso		INT(2)
)ENGINE=InnoDB;

/* Crea la tabella TariffeBagaglio*/

CREATE TABLE TariffeBagagli(
	idBagaglio	INT,
	idCompagnia	INT,
	prezzo		INT,
	PRIMARY KEY(idBagaglio,idCompagnia),
	FOREIGN KEY(idBagaglio) REFERENCES Bagagli(idBagaglio) 
				ON UPDATE CASCADE,
	FOREIGN KEY(idCompagnia) REFERENCES Compagnie(idCompagnia)
				 ON UPDATE CASCADE
)ENGINE=InnoDB;



/* Crea la tabella Tratta */

CREATE TABLE Tratte (
	idTratta	INT AUTO_INCREMENT PRIMARY KEY,
	da			INT NOT NULL,
	a			INT NOT NULL,
	FOREIGN KEY (a) REFERENCES Aeroporti (idAeroporto)
		        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (da) REFERENCES Aeroporti (idAeroporto)
			 ON DELETE CASCADE  ON UPDATE CASCADE
)ENGINE=InnoDB;

/* Crea la tabella Voli */

CREATE TABLE Voli (
	idVolo		VARCHAR(7) PRIMARY KEY,
	oraP		TIME NOT NULL,
	oraA		TIME NOT NULL,
	idTratta	INT NOT NULL,
	idCompagnia	INT NOT NULL,
	FOREIGN KEY (idCompagnia)REFERENCES Compagnie (idCompagnia)
				 ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(idTratta) 	REFERENCES Tratte (idTratta) 
				ON UPDATE CASCADE
) ENGINE=InnoDB;

/* Crea la tabella Viaggi */

CREATE TABLE Viaggi (
	idViaggio	INT AUTO_INCREMENT PRIMARY KEY,
	giorno		DATE NOT NULL,
	stato		ENUM('effettuato','previsto','soppresso') DEFAULT 'previsto',
	comandante	INT(10) NOT NULL, 
	vice		INT(10)NOT NULL,
	prezzoPrima INT,
	prezzoSeconda INT NOT NULL,
	idTratta	INT NOT NULL,
	idCompagniaEsec INT NOT NULL,
	inseritoDa   INT NOT NULL,       
	FOREIGN KEY (InseritoDa) REFERENCES Utenti (idAnag)
								ON UPDATE CASCADE,
	FOREIGN KEY (comandante) REFERENCES Dipendenti (matricola)
				 ON UPDATE CASCADE,
	FOREIGN KEY (vice) REFERENCES Dipendenti (matricola)
			   ON UPDATE CASCADE,
	FOREIGN KEY (idTratta) REFERENCES Tratte (idTratta)
			   ON UPDATE CASCADE,
	FOREIGN KEY (idCompagniaEsec) REFERENCES Compagnie (idCompagnia)
			   ON UPDATE CASCADE			   
) ENGINE=InnoDB;


/* Crea la tabella Scali */

CREATE TABLE Scali(
	idItinerario		INT,
	idAeroporto		INT,
	ordine			INT,
	PRIMARY KEY(idItinerario,idAeroporto),
	FOREIGN KEY(idItinerario) 		REFERENCES Itinerari (idItinerario),
	FOREIGN KEY(idAeroporto)	REFERENCES Aeroporti (idAeroporto)
)ENGINE=InnoDB;


/* Crea la tabella delle Offerte */

CREATE TABLE Offerte (
       idItinerario	INT PRIMARY KEY,
       scontoperc	INT,
       disponibili	INT,
       FOREIGN KEY (idItinerario) 	REFERENCES Itinerari (idItinerario)
                            	ON UPDATE CASCADE
) ENGINE=InnoDB;


/* Crea la tabella delle Assistenze */

CREATE TABLE Assistenze (
       idViaggio	INT,
       matricola	INT(10),
       PRIMARY KEY (idViaggio,matricola),
       FOREIGN KEY (idViaggio) 	REFERENCES Viaggi (idViaggio)
                            	ON UPDATE CASCADE,
       FOREIGN KEY (matricola) REFERENCES Dipendenti (matricola)
                            	ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


/* Crea la tabella Posti */

CREATE TABLE Posti(
	idPosto		INT AUTO_INCREMENT PRIMARY KEY,
	numero		VARCHAR(3),
	aereo		VARCHAR(10) NOT NULL,
	FOREIGN KEY (aereo) 		REFERENCES Aerei (matricola)
                            	ON DELETE CASCADE ON UPDATE CASCADE  

)ENGINE=InnoDB;

/* Crea la tabella Prenotazioni */

CREATE TABLE Prenotazioni (
	idPrenotazione	INT(100) AUTO_INCREMENT PRIMARY KEY,
	idViaggio	INT NOT NULL,
	acquirente	INT NOT NULL,
	passeggero	INT NOT NULL,
	numeroBagagli	INT(3),
	type		ENUM('prima','seconda') DEFAULT 'seconda',
	stato		ENUM('valido','annullato','rimborsato') DEFAULT 'valido',
	prezzoPrenotazione INT,
	idPosto		INT,
	FOREIGN KEY (idPosto)	REFERENCES Posti (idPosto) 
				ON UPDATE CASCADE,
	FOREIGN KEY (idViaggio)	REFERENCES Viaggi (idViaggio)
                            	ON UPDATE CASCADE,
	FOREIGN KEY (acquirente)REFERENCES Utenti (idAnag)
                            	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (passeggero)REFERENCES Anagrafiche (idAnag)
                            	ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


/* Crea la tabella Itinerari*/

CREATE TABLE Itinerari(
	idItinerario	INT AUTO_INCREMENT PRIMARY KEY,
	idTratta		INT,
	giorno			DATE NOT NULL,
	prezzoPrima		INT,
	prezzoSeconda	INT,
	stato		ENUM('effettuato','previsto','soppresso') DEFAULT 'previsto',
	FOREIGN KEY (idTratta)	REFERENCES Tratte (idTratta)
								ON UPDATE CASCADE
)ENGINE=InnoDB;

/* Crea la tabella DettagliItinerari*/

CREATE TABLE DettagliItinerari(
	idItinerario	INT ,
	idViaggio		INT,
	PRIMARY KEY(idItinerario,idViaggio),
	FOREIGN KEY (idItinerario)	REFERENCES Itinerari (idItinerario)
								ON UPDATE CASCADE ,
	
	FOREIGN KEY (idViaggio) REFERENCES Viaggi (idViaggio)
							ON UPDATE CASCADE

)ENGINE=InnoDB;


/*
LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/Filesdb/Assistenze.txt' INTO TABLE Assistenze FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' IGNORE 4 LINES;
*/
SET FOREIGN_KEY_CHECKS = 1;

