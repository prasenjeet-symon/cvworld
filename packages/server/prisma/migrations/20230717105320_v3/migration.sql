/*
  Warnings:

  - Added the required column `previewImgUrl` to the `ResumeTemplateMarketplace` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `resumetemplatemarketplace` ADD COLUMN `previewImgUrl` VARCHAR(191) NOT NULL;
