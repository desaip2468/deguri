-- MySQL dump 10.16  Distrib 10.2.23-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: desaip
-- ------------------------------------------------------
-- Server version	10.2.23-MariaDB-1:10.2.23+maria~bionic-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `panel_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `age` char(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_smsdate_price` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_code1` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_code2` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name1` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name2` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `card_payment_type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `card_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_code` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_group_code` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_registration_month` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_registration_date` char(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_registration_time` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_code` char(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_store` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_price` int(10) DEFAULT NULL,
  `approval_real_price` int(10) DEFAULT NULL,
  `price` int(10) DEFAULT NULL,
  `approval_method` int(4) DEFAULT NULL,
  `approval_date` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_time` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_from` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `origin_table` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_registration_timestamp` datetime DEFAULT NULL,
  `registration_timestamp` datetime NOT NULL,
  KEY `index_approval_type_on_payments` (`approval_type`),
  KEY `index_approval_store_on_payments` (`approval_store`),
  KEY `index_panel_id_on_payments` (`panel_id`),
  KEY `index_company_code_on_payments` (`company_code`),
  KEY `index_approval_store_panel_id_on_payments` (`approval_store`,`panel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `simple_payments`
--

DROP TABLE IF EXISTS `simple_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `simple_payments` (
  `panel_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `age` char(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_sim_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pattern_id` char(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_code` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_group_code` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_registration_timestamp` char(17) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_registration_month` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_registration_date` char(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_registration_time` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_code` char(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `originating_address` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `package_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_type` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_approval_type` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `link_company` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `link_originating_address` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_status` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tel_company` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_store` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_store_detail` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_original_price` int(10) DEFAULT NULL,
  `approval_price` int(10) DEFAULT NULL,
  `approval_unit` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_real_price` int(10) DEFAULT NULL,
  `accumulated_price` int(10) DEFAULT NULL,
  `residual_limit` int(10) DEFAULT NULL,
  `approval_point` int(10) DEFAULT NULL,
  `point_balance` int(10) DEFAULT NULL,
  `approval_method` int(4) DEFAULT NULL,
  `approval_date` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_time` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_usable_data` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_from` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_source` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_channel` char(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registration_timestamp` datetime NOT NULL,
  KEY `index_payment_approval_type_on_payments` (`payment_approval_type`),
  KEY `index_approval_store_on_payments` (`approval_store`),
  KEY `index_panel_id_on_payments` (`panel_id`),
  KEY `index_company_code_on_payments` (`company_code`),
  KEY `index_approval_store_panel_id_on_payments` (`approval_store`,`panel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-04-13 11:11:37
