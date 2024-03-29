-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.0.21-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for photos
CREATE DATABASE IF NOT EXISTS `photos` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `photos`;

-- Dumping structure for table photos.cameras
CREATE TABLE IF NOT EXISTS `cameras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `photographer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.collections
CREATE TABLE IF NOT EXISTS `collections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `start_at` datetime DEFAULT NULL,
  `end_at` datetime DEFAULT NULL,
  `automatic` bit(1) DEFAULT b'1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.collection_files
CREATE TABLE IF NOT EXISTS `collection_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `collection_id` int(11) DEFAULT NULL,
  `file_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.collection_keywords
CREATE TABLE IF NOT EXISTS `collection_keywords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `collection_id` int(11) DEFAULT NULL,
  `keyword_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.collection_photographers
CREATE TABLE IF NOT EXISTS `collection_photographers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `collection_id` int(11) DEFAULT NULL,
  `photographer_id` int(11) DEFAULT NULL,
  `start_at` datetime DEFAULT NULL,
  `end_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.files
CREATE TABLE IF NOT EXISTS `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(500) DEFAULT NULL,
  `folder_path` varchar(500) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `extension` varchar(25) DEFAULT NULL,
  `folder_id` int(11) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `favourite` bit(1) DEFAULT b'0',
  `created_at` datetime DEFAULT NULL,
  `server_file_id` int(11) DEFAULT NULL,
  `hide` bit(1) NOT NULL DEFAULT b'0',
  `camera_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `Folder ID File` (`folder_id`,`name`,`extension`)
) ENGINE=InnoDB AUTO_INCREMENT=82999 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.files_import
CREATE TABLE IF NOT EXISTS `files_import` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(500) DEFAULT NULL,
  `folder_path` varchar(500) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `extension` varchar(25) DEFAULT NULL,
  `folder_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=92066 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.file_keywords
CREATE TABLE IF NOT EXISTS `file_keywords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) DEFAULT NULL,
  `keyword_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.file_people
CREATE TABLE IF NOT EXISTS `file_people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.folders
CREATE TABLE IF NOT EXISTS `folders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(500) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `parent_folder_id` int(11) DEFAULT NULL,
  `owner_person_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=988 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.keywords
CREATE TABLE IF NOT EXISTS `keywords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.photographers
CREATE TABLE IF NOT EXISTS `photographers` (
  `person_id` int(11) NOT NULL,
  `folder` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table photos.photo_info_to_transfer
CREATE TABLE IF NOT EXISTS `photo_info_to_transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(500) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=331 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
