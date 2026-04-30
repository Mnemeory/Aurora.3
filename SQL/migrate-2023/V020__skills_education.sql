--
-- Implemented in PR #21853.
-- Add education and skills.
--

ALTER TABLE `ss13_characters` ADD COLUMN `education_field` VARCHAR(128) DEFAULT NULL AFTER `origin`;
ALTER TABLE `ss13_characters` ADD COLUMN `education_level` VARCHAR(128) DEFAULT NULL AFTER `education_field`;
ALTER TABLE `ss13_characters` ADD COLUMN `education_background` VARCHAR(128) DEFAULT NULL AFTER `education_level`;
ALTER TABLE `ss13_characters` ADD COLUMN `skills` VARCHAR(256) DEFAULT NULL AFTER `education_background`;
