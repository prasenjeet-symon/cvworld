-- CreateTable
CREATE TABLE `UPIPaymentSubscription` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `transactionId` INTEGER NOT NULL,
    `vpa` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `mobile` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `UPIPaymentSubscription_transactionId_key`(`transactionId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `UPIPaymentSubscription` ADD CONSTRAINT `UPIPaymentSubscription_transactionId_fkey` FOREIGN KEY (`transactionId`) REFERENCES `SubscriptionTransaction`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
