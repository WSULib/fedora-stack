-- MySQL dump 10.13  Distrib 5.5.44, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: proai
-- ------------------------------------------------------
-- Server version	5.5.44-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `rcAdmin`
--

DROP TABLE IF EXISTS `rcAdmin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rcAdmin` (
  `pollingEnabled` int(11) NOT NULL,
  `identifyPath` varchar(28) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rcFailure`
--

DROP TABLE IF EXISTS `rcFailure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rcFailure` (
  `identifier` varchar(255) NOT NULL,
  `mdPrefix` varchar(255) NOT NULL,
  `sourceInfo` text NOT NULL,
  `failCount` int(11) NOT NULL,
  `firstFailDate` varchar(20) NOT NULL,
  `lastFailDate` varchar(20) NOT NULL,
  `lastFailReason` text NOT NULL,
  PRIMARY KEY (`identifier`,`mdPrefix`),
  KEY `failCount` (`failCount`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rcFormat`
--

DROP TABLE IF EXISTS `rcFormat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rcFormat` (
  `formatKey` int(11) NOT NULL AUTO_INCREMENT,
  `mdPrefix` varchar(255) NOT NULL,
  `namespaceURI` varchar(255) NOT NULL,
  `schemaLocation` varchar(255) NOT NULL,
  `lastPollDate` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`formatKey`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rcItem`
--

DROP TABLE IF EXISTS `rcItem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rcItem` (
  `itemKey` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  PRIMARY KEY (`itemKey`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=153657 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rcMembership`
--

DROP TABLE IF EXISTS `rcMembership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rcMembership` (
  `setKey` int(11) NOT NULL,
  `recordKey` int(11) NOT NULL,
  KEY `setKey` (`setKey`),
  KEY `recordKey` (`recordKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rcPrunable`
--

DROP TABLE IF EXISTS `rcPrunable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rcPrunable` (
  `pruneKey` bigint(20) NOT NULL AUTO_INCREMENT,
  `xmlPath` varchar(28) NOT NULL,
  PRIMARY KEY (`pruneKey`)
) ENGINE=InnoDB AUTO_INCREMENT=1068894 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rcQueue`
--

DROP TABLE IF EXISTS `rcQueue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rcQueue` (
  `queueKey` bigint(20) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `mdPrefix` varchar(255) NOT NULL,
  `sourceInfo` text NOT NULL,
  `queueSource` varchar(1) NOT NULL,
  PRIMARY KEY (`queueKey`)
) ENGINE=InnoDB AUTO_INCREMENT=262198 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rcRecord`
--

DROP TABLE IF EXISTS `rcRecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rcRecord` (
  `recordKey` int(11) NOT NULL AUTO_INCREMENT,
  `itemKey` int(11) NOT NULL,
  `formatKey` int(11) NOT NULL,
  `modDate` bigint(20) DEFAULT NULL,
  `xmlPath` varchar(28) NOT NULL,
  PRIMARY KEY (`recordKey`),
  KEY `itemKey` (`itemKey`),
  KEY `formatKey` (`formatKey`),
  KEY `modDate` (`modDate`),
  KEY `xmlPath` (`xmlPath`)
) ENGINE=InnoDB AUTO_INCREMENT=306838 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rcSet`
--

DROP TABLE IF EXISTS `rcSet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rcSet` (
  `setKey` int(11) NOT NULL AUTO_INCREMENT,
  `setSpec` varchar(255) NOT NULL,
  `xmlPath` varchar(28) NOT NULL,
  PRIMARY KEY (`setKey`),
  KEY `xmlPath` (`xmlPath`)
) ENGINE=InnoDB AUTO_INCREMENT=427 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-01-05 10:07:47
