-- MySQL dump 10.13  Distrib 5.7.34, for Linux (x86_64)
--
-- Host: localhost    Database: nika
-- ------------------------------------------------------
-- Server version	5.7.34

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
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `article_title` varchar(255) NOT NULL,
  `article_date` date NOT NULL,
  `article_text` text NOT NULL,
  `article_author` varchar(50) DEFAULT NULL,
  `category_id` int(11) unsigned NOT NULL DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `active` (`active`),
  KEY `article_date` (`article_date`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `articles_keywords`
--

DROP TABLE IF EXISTS `articles_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles_keywords` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(11) unsigned NOT NULL,
  `keyword_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `article_id` (`article_id`),
  KEY `keyword_id` (`keyword_id`),
  CONSTRAINT `articles_keywords` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles_keywords`
--

LOCK TABLES `articles_keywords` WRITE;
/*!40000 ALTER TABLE `articles_keywords` DISABLE KEYS */;
/*!40000 ALTER TABLE `articles_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(11) unsigned NOT NULL,
  `quantity` int(11) unsigned NOT NULL DEFAULT '1',
  `user_id` int(11) unsigned NOT NULL,
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `user_id` (`user_id`),
  KEY `added` (`added`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `catalog_categories`
--

DROP TABLE IF EXISTS `catalog_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_categories` (
  `category_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `category_pid` int(10) unsigned DEFAULT NULL COMMENT 'ID ???????????? ?????????',
  `category_title` varchar(255) NOT NULL,
  `category_alternative_title` varchar(255) DEFAULT NULL COMMENT '?????????????? ???????????? ????????? ??????. ?? ???????????? ?? ?????',
  `category_tag` varchar(20) NOT NULL COMMENT '??? ?????????',
  `category_description` text COMMENT '???????? ?????????',
  `category_description_short` varchar(255) DEFAULT NULL COMMENT '??????? ???????? ??????????????',
  `is_leaf` enum('true','false') NOT NULL DEFAULT 'false' COMMENT '??????? - ???????? ?? ????????? ????????, ?? ???? ?????????? ? ??? ?????? (true) ??? ????????? (false)',
  `show_image` enum('true','false') NOT NULL DEFAULT 'false' COMMENT '??????? ???????????',
  `order_left` int(11) unsigned DEFAULT NULL,
  `order_right` int(11) unsigned DEFAULT NULL,
  `order_level` tinyint(3) unsigned DEFAULT NULL,
  `order_id` int(10) unsigned DEFAULT '0',
  `category_view` enum('list','icons','plate') NOT NULL DEFAULT 'icons',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`category_id`),
  KEY `order_left` (`order_left`),
  KEY `order_right` (`order_right`),
  KEY `category_pid` (`category_pid`),
  KEY `order_id` (`order_id`),
  KEY `category_tag` (`category_tag`),
  KEY `category_title` (`category_title`),
  KEY `category_alternative_title` (`category_alternative_title`),
  KEY `is_leaf` (`is_leaf`),
  KEY `order_level` (`order_level`),
  CONSTRAINT `tree` FOREIGN KEY (`category_pid`) REFERENCES `catalog_categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=328 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `catalog_categories_items`
--

DROP TABLE IF EXISTS `catalog_categories_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_categories_items` (
  `category_id` int(11) unsigned NOT NULL COMMENT 'ID ?????????',
  `item_id` int(11) unsigned NOT NULL COMMENT 'ID ??????',
  PRIMARY KEY (`category_id`,`item_id`),
  KEY `category_id` (`category_id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `catalog_category_features`
--

DROP TABLE IF EXISTS `catalog_category_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_features` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(11) unsigned NOT NULL,
  `feature_id` int(11) unsigned NOT NULL,
  `marked` enum('true','false') NOT NULL DEFAULT 'false',
  `feature_order` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `feature_id` (`feature_id`),
  KEY `feature_order` (`feature_order`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `catalog_category_keywords`
--

DROP TABLE IF EXISTS `catalog_category_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_keywords` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(11) unsigned NOT NULL,
  `keyword_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `catalog_features`
--

DROP TABLE IF EXISTS `catalog_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_features` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT 'Наименование характеристики',
  `unit` varchar(255) DEFAULT NULL COMMENT 'Единица измерения характеристики',
  PRIMARY KEY (`id`),
  KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=895 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `catalog_items`
--

DROP TABLE IF EXISTS `catalog_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_items` (
  `item_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID ??????',
  `item_title` varchar(255) NOT NULL COMMENT '???????????? ??????',
  `item_key` varchar(15) NOT NULL COMMENT '??????? ??????',
  `item_title_alternative` varchar(255) DEFAULT NULL COMMENT '?????????????? ???????????? ??????',
  `item_description` text COMMENT '???????? ??????',
  `item_description_short` varchar(255) DEFAULT NULL COMMENT '???????? ???????? ??????',
  `show_image` enum('true','false') NOT NULL DEFAULT 'true' COMMENT '???? ?? ??? ?????? ??????????',
  `item_unit` varchar(20) DEFAULT NULL,
  `order_level` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `availability` tinyint(1) NOT NULL DEFAULT '0',
  `price` float(9,2) unsigned NOT NULL DEFAULT '0.00',
  `price2` float(9,2) NOT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `item_new` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `price_warn` int(1) unsigned DEFAULT '0',
  `commission` int(1) unsigned DEFAULT '0',
  `arrives_in` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  KEY `show_picture` (`show_image`),
  KEY `item_key` (`item_key`),
  KEY `item_title` (`item_title`),
  KEY `item_new` (`item_new`),
  KEY `order_level` (`order_level`),
  KEY `order_id` (`order_id`),
  KEY `price` (`price`)
) ENGINE=InnoDB AUTO_INCREMENT=3584 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `catalog_items_features`
--

DROP TABLE IF EXISTS `catalog_items_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_items_features` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(11) unsigned NOT NULL,
  `feature_id` int(11) unsigned NOT NULL,
  `feature_value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_feature` (`feature_id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20848 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `catalog_items_keywords`
--

DROP TABLE IF EXISTS `catalog_items_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_items_keywords` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(11) unsigned NOT NULL,
  `keyword_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=72524 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `catalog_items_reviews`
--

DROP TABLE IF EXISTS `catalog_items_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_items_reviews` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `rating` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rate_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `review` mediumtext,
  `user_id` bigint(20) NOT NULL,
  `item_id` bigint(20) NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `rate_date` (`rate_date`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content`
--

DROP TABLE IF EXISTS `content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content` (
  `content_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `content_title` varchar(255) NOT NULL,
  `content_text` mediumtext NOT NULL,
  `content_label` varchar(50) NOT NULL DEFAULT 'news',
  `content_order` int(11) unsigned NOT NULL,
  `content_type` enum('news','system','article','content') NOT NULL DEFAULT 'news',
  `content_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`content_id`),
  UNIQUE KEY `content_id` (`content_id`),
  KEY `content_order` (`content_order`),
  KEY `content_date` (`content_date`),
  KEY `content_label` (`content_label`),
  KEY `content_type` (`content_type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `images` (
  `image_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` tinyint(4) unsigned NOT NULL COMMENT '??? ???????? - ?????, ?????????, ??????? ? ?.?.',
  `image_file` varchar(64) NOT NULL COMMENT '??? ????? ? ????????????',
  `default_image` enum('true','false') NOT NULL DEFAULT 'false',
  `item_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `type_id` (`type_id`),
  KEY `item_id` (`item_id`),
  KEY `default_image` (`default_image`),
  KEY `image_file` (`image_file`)
) ENGINE=InnoDB AUTO_INCREMENT=3993 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `keywords`
--

DROP TABLE IF EXISTS `keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `keywords` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `keyword` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `keyword` (`keyword`)
) ENGINE=InnoDB AUTO_INCREMENT=4403 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(11) unsigned NOT NULL,
  `quantity` int(11) unsigned NOT NULL,
  `order_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `order_date` datetime NOT NULL,
  `order_status` enum('added','queued','rejected','closed','deleted') NOT NULL DEFAULT 'added',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `order_date` (`order_date`),
  KEY `order_status` (`order_status`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qa`
--

DROP TABLE IF EXISTS `qa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qa` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `question` text NOT NULL,
  `status` enum('queued','closed') NOT NULL DEFAULT 'queued',
  `phone` varchar(50) DEFAULT NULL,
  `answer` text,
  `item_id` int(11) unsigned NOT NULL DEFAULT '0',
  `category_id` int(11) unsigned NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `published_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `category_id` (`category_id`),
  KEY `status` (`status`),
  KEY `published_date` (`published_date`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=34381 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `login` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `name` varchar(150) DEFAULT NULL,
  `is_active` enum('false',' true') NOT NULL DEFAULT 'false',
  `is_activated` enum('false',' true') NOT NULL DEFAULT 'false',
  `email` varchar(50) NOT NULL,
  `registered_date` datetime NOT NULL,
  `akey` varchar(64) DEFAULT NULL,
  `phone` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `key` (`akey`),
  KEY `registered_date` (`registered_date`)
) ENGINE=InnoDB AUTO_INCREMENT=13059 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-09 20:27:06
