-- AlterTable
ALTER TABLE `feedback` ADD COLUMN `attachment` VARCHAR(191) NULL,
    MODIFY `description` LONGTEXT NOT NULL;
