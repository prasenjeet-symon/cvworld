/*
  Warnings:

  - A unique constraint covering the columns `[adminId]` on the table `PremiumTemplatePlans` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX `PremiumTemplatePlans_adminId_key` ON `PremiumTemplatePlans`(`adminId`);
