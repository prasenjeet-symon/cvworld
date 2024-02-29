/*
  Warnings:

  - A unique constraint covering the columns `[identifier]` on the table `Courses` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[identifier]` on the table `Educations` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[identifier]` on the table `EmploymentHistories` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[identifier]` on the table `Internships` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[identifier]` on the table `Languages` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[identifier]` on the table `Links` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[identifier]` on the table `Skills` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `identifier` to the `Courses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `identifier` to the `Educations` table without a default value. This is not possible if the table is not empty.
  - Added the required column `identifier` to the `EmploymentHistories` table without a default value. This is not possible if the table is not empty.
  - Added the required column `identifier` to the `Internships` table without a default value. This is not possible if the table is not empty.
  - Added the required column `identifier` to the `Languages` table without a default value. This is not possible if the table is not empty.
  - Added the required column `identifier` to the `Links` table without a default value. This is not possible if the table is not empty.
  - Added the required column `identifier` to the `Skills` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `courses` ADD COLUMN `identifier` VARCHAR(255) NOT NULL;

-- AlterTable
ALTER TABLE `educations` ADD COLUMN `identifier` VARCHAR(255) NOT NULL;

-- AlterTable
ALTER TABLE `employmenthistories` ADD COLUMN `identifier` VARCHAR(255) NOT NULL;

-- AlterTable
ALTER TABLE `internships` ADD COLUMN `identifier` VARCHAR(255) NOT NULL;

-- AlterTable
ALTER TABLE `languages` ADD COLUMN `identifier` VARCHAR(255) NOT NULL;

-- AlterTable
ALTER TABLE `links` ADD COLUMN `identifier` VARCHAR(255) NOT NULL;

-- AlterTable
ALTER TABLE `skills` ADD COLUMN `identifier` VARCHAR(255) NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX `Courses_identifier_key` ON `Courses`(`identifier`);

-- CreateIndex
CREATE UNIQUE INDEX `Educations_identifier_key` ON `Educations`(`identifier`);

-- CreateIndex
CREATE UNIQUE INDEX `EmploymentHistories_identifier_key` ON `EmploymentHistories`(`identifier`);

-- CreateIndex
CREATE UNIQUE INDEX `Internships_identifier_key` ON `Internships`(`identifier`);

-- CreateIndex
CREATE UNIQUE INDEX `Languages_identifier_key` ON `Languages`(`identifier`);

-- CreateIndex
CREATE UNIQUE INDEX `Links_identifier_key` ON `Links`(`identifier`);

-- CreateIndex
CREATE UNIQUE INDEX `Skills_identifier_key` ON `Skills`(`identifier`);
