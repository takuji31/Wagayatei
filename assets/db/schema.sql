DROP TABLE IF EXISTS `genre`;
CREATE TABLE `genre` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `label` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'label',
  `name` varchar(32) NOT NULL COMMENT 'name',
  `created_at` datetime DEFAULT NULL COMMENT 'created_at',
  `updated_at` datetime DEFAULT NULL COMMENT 'updated_at',
  PRIMARY KEY (`id`),
  UNIQUE KEY `label` (`label`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pc`;
CREATE TABLE `pc` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'uuid',
  `user_id` int(10) unsigned NOT NULL COMMENT 'user_id',
  `main_fg` enum('yes','no') NOT NULL DEFAULT 'no' COMMENT 'main_fg',
  `name` varchar(16) NOT NULL COMMENT 'name',
  `profile` text,
  `status` enum('private','public','deleted') NOT NULL DEFAULT 'private' COMMENT 'status',
  `rank` enum('member','sub','master') NOT NULL DEFAULT 'member',
  `created_at` datetime DEFAULT NULL COMMENT 'created_on',
  `updated_at` datetime DEFAULT NULL COMMENT 'updated_on',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pc_IX1` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pc_skill`;
CREATE TABLE `pc_skill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `pc_id` int(10) unsigned NOT NULL COMMENT 'pc_id',
  `skill_id` int(10) unsigned NOT NULL COMMENT 'skill_id',
  `rank` int(11) unsigned NOT NULL COMMENT 'rank',
  `created_at` datetime DEFAULT NULL COMMENT 'created_at',
  `updated_at` datetime DEFAULT NULL COMMENT 'updated_at',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `skill`;
CREATE TABLE `skill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'uuid',
  `name` varchar(32) NOT NULL COMMENT 'name',
  `min` int(11) NOT NULL COMMENT 'rank',
  `max` int(11) NOT NULL,
  `type_data` varchar(255) NOT NULL,
  `genre_id` int(10) unsigned NOT NULL COMMENT 'genre_id',
  `created_at` datetime DEFAULT NULL COMMENT 'created_at',
  `updated_at` datetime DEFAULT NULL COMMENT 'updated_at',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'uuid',
  `twitter_id` varchar(255) NOT NULL COMMENT 'TwitterのユーザーID',
  `screen_name` varchar(255) NOT NULL COMMENT 'スクリーン名',
  `token` varchar(255) NOT NULL COMMENT 'OAuth Token',
  `token_secret` varchar(255) NOT NULL COMMENT 'OAuth Token Secret',
  `name` varchar(32) NOT NULL COMMENT 'ユーザー名',
  `status` enum('created','accepted','admin','deleted') DEFAULT 'created' COMMENT 'ステータス',
  `created_at` datetime DEFAULT NULL COMMENT '作成日',
  `updated_at` datetime DEFAULT NULL COMMENT '更新日',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
