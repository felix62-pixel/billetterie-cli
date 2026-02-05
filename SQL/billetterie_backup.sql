-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: localhost    Database: Billetterie
-- ------------------------------------------------------
-- Server version	8.0.44-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Caisse`
--

DROP TABLE IF EXISTS `Caisse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Caisse` (
  `idCaisse` varchar(10) NOT NULL,
  `etat` varchar(20) DEFAULT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `idUser` int DEFAULT NULL,
  PRIMARY KEY (`idCaisse`),
  UNIQUE KEY `idUser` (`idUser`),
  CONSTRAINT `Caisse_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `Utilisateur` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Caisse`
--

LOCK TABLES `Caisse` WRITE;
/*!40000 ALTER TABLE `Caisse` DISABLE KEYS */;
INSERT INTO `Caisse` VALUES ('C01','OUVERTE','001',2),('C02','FERMEE','002',3);
/*!40000 ALTER TABLE `Caisse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Client`
--

DROP TABLE IF EXISTS `Client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Client` (
  `codeClient` varchar(10) NOT NULL,
  `nomClient` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`codeClient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Client`
--

LOCK TABLES `Client` WRITE;
/*!40000 ALTER TABLE `Client` DISABLE KEYS */;
INSERT INTO `Client` VALUES ('CL01','Dupont','dupont@gmail.com'),('CL02','Martin','martin@gmail.com'),('CL03','Durand','durand@gmail.com');
/*!40000 ALTER TABLE `Client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservation`
--

DROP TABLE IF EXISTS `Reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reservation` (
  `id` int NOT NULL,
  `dateR` date NOT NULL,
  `heure` time NOT NULL,
  `nombreTickets` int DEFAULT NULL,
  `codeClient` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `codeClient` (`codeClient`),
  CONSTRAINT `Reservation_ibfk_1` FOREIGN KEY (`codeClient`) REFERENCES `Client` (`codeClient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservation`
--

LOCK TABLES `Reservation` WRITE;
/*!40000 ALTER TABLE `Reservation` DISABLE KEYS */;
INSERT INTO `Reservation` VALUES (2001,'2026-02-05','14:30:00',2,'CL01'),(2002,'2026-02-06','16:00:00',3,'CL02');
/*!40000 ALTER TABLE `Reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tickets`
--

DROP TABLE IF EXISTS `Tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tickets` (
  `idTickets` int NOT NULL,
  `date` date DEFAULT NULL,
  `statut` varchar(20) DEFAULT NULL,
  `prix` int DEFAULT NULL,
  `idVente` int DEFAULT NULL,
  `idReservation` int DEFAULT NULL,
  PRIMARY KEY (`idTickets`),
  KEY `idVente` (`idVente`),
  KEY `idReservation` (`idReservation`),
  CONSTRAINT `Tickets_ibfk_1` FOREIGN KEY (`idVente`) REFERENCES `Vente` (`idVente`),
  CONSTRAINT `Tickets_ibfk_2` FOREIGN KEY (`idReservation`) REFERENCES `Reservation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tickets`
--

LOCK TABLES `Tickets` WRITE;
/*!40000 ALTER TABLE `Tickets` DISABLE KEYS */;
INSERT INTO `Tickets` VALUES (3001,'2026-02-01','VALIDE',4000,1001,NULL),(3002,'2026-02-01','VALIDE',4000,1001,NULL),(3003,'2026-02-02','ANNULE',8000,1002,NULL),(3004,'2026-02-05','RESERVE',3500,NULL,2001),(3005,'2026-02-05','RESERVE',3500,NULL,2001),(3006,'2026-02-06','RESERVE',3000,NULL,2002);
/*!40000 ALTER TABLE `Tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Utilisateur`
--

DROP TABLE IF EXISTS `Utilisateur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Utilisateur` (
  `idUser` int NOT NULL,
  `nom` varchar(50) NOT NULL,
  `motDePasse` varchar(50) NOT NULL,
  `role` varchar(20) NOT NULL,
  PRIMARY KEY (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utilisateur`
--

LOCK TABLES `Utilisateur` WRITE;
/*!40000 ALTER TABLE `Utilisateur` DISABLE KEYS */;
INSERT INTO `Utilisateur` VALUES (1,'Admin','admin123','ADMIN'),(2,'Jean','jean123','CAISSIER'),(3,'Marie','marie123','CAISSIER');
/*!40000 ALTER TABLE `Utilisateur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Vente`
--

DROP TABLE IF EXISTS `Vente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Vente` (
  `idVente` int NOT NULL,
  `dateVente` date NOT NULL,
  `montant` float NOT NULL,
  `idUser` int DEFAULT NULL,
  `idCaisse` varchar(10) DEFAULT NULL,
  `codeClient` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idVente`),
  KEY `idUser` (`idUser`),
  KEY `idCaisse` (`idCaisse`),
  KEY `codeClient` (`codeClient`),
  CONSTRAINT `Vente_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `Utilisateur` (`idUser`),
  CONSTRAINT `Vente_ibfk_2` FOREIGN KEY (`idCaisse`) REFERENCES `Caisse` (`idCaisse`),
  CONSTRAINT `Vente_ibfk_3` FOREIGN KEY (`codeClient`) REFERENCES `Client` (`codeClient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Vente`
--

LOCK TABLES `Vente` WRITE;
/*!40000 ALTER TABLE `Vente` DISABLE KEYS */;
INSERT INTO `Vente` VALUES (1001,'2026-02-01',12000,2,'C01','CL01'),(1002,'2026-02-02',8000,3,'C02','CL02'),(1003,'2026-02-03',15000,2,'C01','CL03');
/*!40000 ALTER TABLE `Vente` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-05  2:24:40
