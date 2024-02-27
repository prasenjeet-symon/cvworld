-- CreateTable
CREATE TABLE `_ResumeTemplateMarketplaceToUser` (
    `A` INTEGER NOT NULL,
    `B` INTEGER NOT NULL,

    UNIQUE INDEX `_ResumeTemplateMarketplaceToUser_AB_unique`(`A`, `B`),
    INDEX `_ResumeTemplateMarketplaceToUser_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `_ResumeTemplateMarketplaceToUser` ADD CONSTRAINT `_ResumeTemplateMarketplaceToUser_A_fkey` FOREIGN KEY (`A`) REFERENCES `ResumeTemplateMarketplace`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_ResumeTemplateMarketplaceToUser` ADD CONSTRAINT `_ResumeTemplateMarketplaceToUser_B_fkey` FOREIGN KEY (`B`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
