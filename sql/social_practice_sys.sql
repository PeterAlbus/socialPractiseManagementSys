CREATE DATABASE  IF NOT EXISTS `social_practice_sys` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `social_practice_sys`;
-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: www.peteralbus.com    Database: social_practice_sys
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity`
--

DROP TABLE IF EXISTS `activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity` (
  `activity_id` bigint NOT NULL,
  `activity_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `activity_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `activity_introduction` text COLLATE utf8mb4_general_ci,
  `min_people` int DEFAULT NULL,
  `max_people` int DEFAULT NULL,
  `version` int DEFAULT '1',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group` (
  `group_id` bigint NOT NULL,
  `group_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `leader_id` bigint DEFAULT NULL,
  `activity_id` bigint DEFAULT NULL,
  `version` int DEFAULT '1',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`group_id`),
  KEY `group_activity_activity_id_fk` (`activity_id`),
  KEY `group_user_user_id_fk` (`leader_id`),
  CONSTRAINT `group_activity_activity_id_fk` FOREIGN KEY (`activity_id`) REFERENCES `activity` (`activity_id`),
  CONSTRAINT `group_user_user_id_fk` FOREIGN KEY (`leader_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `manage`
--

DROP TABLE IF EXISTS `manage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manage` (
  `management_id` bigint NOT NULL,
  `activity_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `version` int DEFAULT '1',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`management_id`),
  KEY `manage_activity_activity_id_fk` (`activity_id`),
  KEY `manage_user_user_id_fk` (`user_id`),
  CONSTRAINT `manage_activity_activity_id_fk` FOREIGN KEY (`activity_id`) REFERENCES `activity` (`activity_id`),
  CONSTRAINT `manage_user_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message` (
  `message_id` bigint NOT NULL,
  `message_title` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `message_receiver` bigint DEFAULT NULL,
  `message_sender` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `message_content` text COLLATE utf8mb4_general_ci,
  `is_read` tinyint(1) DEFAULT NULL,
  `version` int DEFAULT '1',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `participate`
--

DROP TABLE IF EXISTS `participate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participate` (
  `participation_id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `activity_id` bigint DEFAULT NULL,
  `group_id` bigint DEFAULT NULL,
  `is_finished` tinyint(1) DEFAULT '0',
  `is_accept` tinyint(1) DEFAULT '0',
  `version` int DEFAULT '1',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`participation_id`),
  KEY `participate_activity_activity_id_fk` (`activity_id`),
  KEY `participate_group_group_id_fk` (`group_id`),
  KEY `participate_user_user_id_fk` (`user_id`),
  CONSTRAINT `participate_activity_activity_id_fk` FOREIGN KEY (`activity_id`) REFERENCES `activity` (`activity_id`),
  CONSTRAINT `participate_group_group_id_fk` FOREIGN KEY (`group_id`) REFERENCES `group` (`group_id`),
  CONSTRAINT `participate_user_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `record`
--

DROP TABLE IF EXISTS `record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `record` (
  `record_id` bigint NOT NULL,
  `participation_id` bigint DEFAULT NULL,
  `record_title` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `record_content` text COLLATE utf8mb4_general_ci,
  `is_read` tinyint(1) DEFAULT '0',
  `version` int DEFAULT '1',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`record_id`),
  KEY `record_participate_participation_id_fk` (`participation_id`),
  CONSTRAINT `record_participate_participation_id_fk` FOREIGN KEY (`participation_id`) REFERENCES `participate` (`participation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `score_group`
--

DROP TABLE IF EXISTS `score_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `score_group` (
  `score_id` bigint NOT NULL,
  `group_id` bigint DEFAULT NULL,
  `teacher_id` bigint DEFAULT NULL,
  `score_value` double DEFAULT NULL,
  `version` int DEFAULT '1',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`score_id`),
  KEY `score_group_group_group_id_fk` (`group_id`),
  KEY `score_group_user_user_id_fk` (`teacher_id`),
  CONSTRAINT `score_group_group_group_id_fk` FOREIGN KEY (`group_id`) REFERENCES `group` (`group_id`),
  CONSTRAINT `score_group_user_user_id_fk` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `score_stu`
--

DROP TABLE IF EXISTS `score_stu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `score_stu` (
  `score_id` bigint NOT NULL,
  `participation_id` bigint DEFAULT NULL,
  `teacher_id` bigint DEFAULT NULL,
  `score_value` double DEFAULT NULL,
  `version` int DEFAULT '1',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`score_id`),
  KEY `score_stu_participate_participation_id_fk` (`participation_id`),
  KEY `score_stu_user_user_id_fk` (`teacher_id`),
  CONSTRAINT `score_stu_participate_participation_id_fk` FOREIGN KEY (`participation_id`) REFERENCES `participate` (`participation_id`),
  CONSTRAINT `score_stu_user_user_id_fk` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` bigint NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `real_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_phone` char(11) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `avatar_src` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_class` int DEFAULT NULL,
  `user_salt` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `version` int DEFAULT '1',
  `gmt_create` datetime DEFAULT NULL,
  `gmt_modified` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_user_phone_uindex` (`user_phone`),
  UNIQUE KEY `user_username_uindex` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-12-25 17:54:41
