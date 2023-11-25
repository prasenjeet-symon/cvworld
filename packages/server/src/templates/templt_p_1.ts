import { Resume, formatDate } from "../utils";

export default function generateResumeHTML(resume: Resume, timeZone: string) {
  return `
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Document</title>
          <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0" />
          <style>
            @import url("https://fonts.googleapis.com/css2?family=Rubik:wght@300;400;500;600&display=swap");
             body {
                background-color: aliceblue;
             }

            .resume {
              padding: 50px;
              font-family: "Rubik", sans-serif;
              width: 210mm;
              height: 297mm;
              margin: 0 auto;
              background-color: white;
            }
  
            .resume > div:nth-of-type(1) {
              display: flex;
              flex-direction: column;
              justify-content: flex-start;
            }
  
            .resume > div:nth-of-type(1) > div:nth-of-type(1) {
              font-size: 1.5rem;
              font-weight: 600;
              margin-bottom: 5px;
            }
  
            .resume > div:nth-of-type(1) > div:nth-of-type(2) {
              font-size: 1rem;
              font-weight: 400;
            }
  
            .lowerBody {
              display: grid;
              grid-template-columns: 2fr 1fr;
              grid-gap: 10px;
            }
  
            .lowerBody .profileSection,
            .lowerBody .employmentSection,
            .lowerBody .educationSection,
            .lowerBody .internshipSection,
            .lowerBody .coursesSection {
              display: flex;
              align-items: flex-start;
              padding: 10px 10px 10px 0px;
              margin: 15px 0px;
            }
  
            .lowerBody .profileSection > div:nth-of-type(2),
            .lowerBody .employmentSection > div:nth-of-type(2),
            .lowerBody .educationSection > div:nth-of-type(2),
            .lowerBody .internshipSection > div:nth-of-type(2),
            .lowerBody .coursesSection > div:nth-of-type(2) {
              flex: 1;
              margin-left: 10px;
            }
  
            .lowerBody .profileSection > div:nth-of-type(2) > div:nth-of-type(1),
            .lowerBody .employmentSection > div:nth-of-type(2) > div:nth-of-type(1),
            .lowerBody .educationSection > div:nth-of-type(2) > div:nth-of-type(1),
            .lowerBody .internshipSection > div:nth-of-type(2) > div:nth-of-type(1),
            .lowerBody .coursesSection > div:nth-of-type(2) > div:nth-of-type(1) {
              font-size: 1rem;
              font-weight: 600;
              margin-bottom: 5px;
            }
  
            /* Profile section */
            .lowerBody .profileSection > div:nth-of-type(2) > div:nth-of-type(2) {
              font-size: 0.9rem;
              font-weight: 400;
            }
  
            /* Employment section */
            .lowerBody .employmentSection .employmentHistoryItem,
            .lowerBody .educationSection .educationSectionItem,
            .lowerBody .internshipSection .internshipSectionItem,
            .lowerBody .coursesSection .coursesSectionItem {
              margin: 10px 0px 20px 0px;
            }
  
            .lowerBody .employmentSection .employmentHistoryItem > div:nth-of-type(1),
            .lowerBody .educationSection .educationSectionItem > div:nth-of-type(1),
            .lowerBody .internshipSection .internshipSectionItem > div:nth-of-type(1),
            .lowerBody .coursesSection .coursesSectionItem > div:nth-of-type(1) {
              font-size: 0.95rem;
              font-weight: 500;
            }
  
            .lowerBody .employmentSection .employmentHistoryItem > div:nth-of-type(2),
            .lowerBody .educationSection .educationSectionItem > div:nth-of-type(2),
            .lowerBody .internshipSection .internshipSectionItem > div:nth-of-type(2),
            .lowerBody .coursesSection .coursesSectionItem > div:nth-of-type(2) {
              font-weight: 200;
              font-size: 0.85rem;
              margin: 5px 0px;
            }
  
            .lowerBody .employmentSection .employmentHistoryItem > div:nth-of-type(3),
            .lowerBody .educationSection .educationSectionItem > div:nth-of-type(3),
            .lowerBody .internshipSection .internshipSectionItem > div:nth-of-type(3),
            .lowerBody .coursesSection .coursesSectionItem > div:nth-of-type(3) {
              font-size: 0.9rem;
              font-weight: 400;
            }
  
            /* Right section */
            .detailsSection > div:nth-of-type(1) {
              font-weight: 500;
            }
            .detailsSection > div:nth-of-type(2) {
              font-size: 0.9rem;
              font-weight: 400;
              margin: 10px 0px;
              line-height: 1.25rem;
            }
  
            .detailsSection > div:nth-of-type(3) {
              color: darkcyan;
              font-size: 0.9rem;
              font-weight: 500;
              margin: 10px 0px;
            }
  
            .detailsSection > div:nth-of-type(4) {
              font-size: 0.9rem;
              font-weight: 400;
              margin: 10px 0px;
              line-height: 1.25rem;
            }
  
            .detailsSection > div:nth-of-type(4) > div:nth-of-type(1) {
              font-weight: 500;
            }
  
            .detailsSection > div:nth-of-type(5) {
              font-size: 0.9rem;
              font-weight: 400;
              margin: 10px 0px;
              line-height: 1.25rem;
            }
  
            .detailsSection > div:nth-of-type(5) > div:nth-of-type(1) {
              font-weight: 500;
            }
  
            .linksSection {
              margin: 20px 0px;
            }
  
            .linksSection > div:nth-of-type(1) {
              font-size: 0.9rem;
              font-weight: 500;
              margin-bottom: 5px;
            }
  
            .linksSection .linkItem {
              color: darkcyan;
              font-weight: 500;
              margin: 0px 10px 5px 0px;
            }
  
            .linksSection .linkItem a {
              text-decoration: none;
              font-size: 0.9rem;
            }
  
            .linksSection > div:nth-of-type(2) {
              display: flex;
              flex-wrap: wrap;
            }
  
            /* For the skill section */
            .skillSection {
              margin: 20px 0px;
              font-size: 0.9rem;
              font-weight: 400;
            }
  
            .skillSection > div:nth-of-type(1) {
              font-weight: 500;
            }
  
            .skillSection .skillItem {
              margin: 10px 0px;
              display: flex;
              flex-direction: column;
              align-items: flex-start;
              justify-content: flex-start;
            }
  
            .skillSection .skillItem > div:nth-of-type(2), .skillSection .skillItem > hr {
              display: inline-block;
              height: 1px;
              border: 0px;
              background-color: white;
              outline: none;
              margin-top: 5px;
              border-bottom: 3px solid black;
            }
  
            /* For the hobbies */
            .hobbiesSection {
              margin: 20px 0px;
              font-size: 0.9rem;
              font-weight: 400;
              line-height: 1.25rem;
            }
  
            .hobbiesSection > div:nth-child(1) {
              font-weight: 500;
              margin-bottom: 5px;
            }
          </style>
        </head>
        <body>
          <section id="resume" class="resume">
            <div class="header">
              <div>${resume.name}</div>
              <div>${resume.profession}</div>
            </div>
            <div class="lowerBody">
              <section>
                <!-- profile section -->
                ${
                  resume.profile
                    ? `
                  <div class="profileSection">
                  <div><span class="material-symbols-outlined"> person </span></div>
                  <div>
                    <div>Profile</div>
                    <div>
                    ${resume.profile}
                    </div>
                  </div>
                </div>
                `
                    : ""
                }
                <!-- employment history section -->
                ${
                  resume.employmentHistory.length !== 0
                    ? `
                    <div class="employmentSection">
                    <div><span class="material-symbols-outlined"> work </span></div>
                    <div>
                      <div>Employment History</div>
                      <div>
                        <!-- list all the employment history here -->
                        ${resume.employmentHistory
                          .map((p) => {
                            return `
                          <div class="employmentHistoryItem">
                          <div>${p.job} at ${p.employer} , ${p.city}</div>
                          <div>${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                          <div>${p.description}</div>
                          </div>
                          `;
                          })
                          .join(" ")}
                      </div>
                    </div>
                  </div>
                `
                    : ""
                }
                ${
                  resume.education.length !== 0
                    ? `
                <div class="educationSection">
                <div><span class="material-symbols-outlined"> school </span></div>
                <div>
                  <div>Education</div>
                  <div>
                    <!-- list all the employment history here -->
                    ${resume.education
                      .map((p) => {
                        return `
                      <div class="educationSectionItem">
                      <div>${p.degree}, ${p.school}, ${p.city}</div>
                      <div>${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                      <div></div>
                      </div>
                      `;
                      })
                      .join(" ")}
                  </div>
                </div>
                </div>
                `
                    : ""
                }
  
                <!-- Internship -->
                ${
                  resume.internship.length !== 0
                    ? `
                <div class="internshipSection">
                <div><span class="material-symbols-outlined"> group </span></div>
                <div>
                  <div>Internship</div>
                  <div>
                    <!-- list all the employment history here -->
                    ${resume.internship
                      .map((p) => {
                        return `
                      <div class="internshipSectionItem">
                      <div>${p.job}, ${p.employer}, ${p.city}</div>
                      <div>${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                      <div>${p.description}</div>
                      </div>
                      `;
                      })
                      .join(" ")}
                  </div>
                </div>
                </div>
                `
                    : ""
                }
  
                <!-- Courses Section -->
                ${
                  resume.courses.length !== 0
                    ? `
                <div class="coursesSection">
                <div><span class="material-symbols-outlined"> book </span></div>
                <div>
                  <div>Courses</div>
                  <div>
                    <!-- list all the employment history here -->
                    ${resume.courses
                      .map((p) => {
                        return `
                      <div class="coursesSectionItem">
                      <div>${p.course}, ${p.institution}</div>
                      <div>${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                      <div></div>
                      </div>
                      `;
                      })
                      .join(" ")}
                  </div>
                </div>
              </div>
                `
                    : ""
                }
              </section>
              <section>
                <!-- details -->
                <div class="detailsSection">
                  <div>Details</div>
                  <div>
                    ${resume.details.address} <br />
                    ${resume.details.city} ${resume.details.postalCode} <br />
                    ${resume.details.country} <br />
                    ${resume.details.phone}
                  </div>
                  <div>${resume.details.email}</div>
                  <div>
                    <div>Date/Place of birth</div>
                    <div>
                      ${formatDate(resume.details.dateOfBirth, timeZone)} <br />
                      ${resume.details.placeOfBirth}
                    </div>
                  </div>
                  <div>
                    <div>Driving license</div>
                    <div>${resume.details.drivingLicense}</div>
                  </div>
                </div>
  
                <!-- links sections -->
                ${
                  resume.links.length !== 0
                    ? `
                <div class="linksSection">
                <div>Links</div>
                <div>
                  ${resume.links
                    .map((p) => {
                      return `<div class="linkItem"><a href="">${p.url}</a></div>`;
                    })
                    .join(" ")}
                </div>
                </div>
                `
                    : ""
                }
  
                <!-- skills section -->
                ${
                  resume.skills.length !== 0
                    ? `
                <div class="skillSection">
                <div>Skills</div>
                <div>
                  ${resume.skills
                    .map((p) => {
                      return `
                    <div class="skillItem">
                    <div>${p.skill}</div>
                    <div style="width: ${p.level}%"></div>
                   </div>
                    `;
                    })
                    .join(" ")}
                </div>
                </div>
                `
                    : ""
                }
  
                <!-- hobbies section -->
                ${
                  resume.hobbies
                    ? `
                <div class="hobbiesSection">
                <div>Hobbies</div>
                <div>
                  ${resume.hobbies}
                </div>
                </div>
                `
                    : ""
                }
  
                <!-- Languages section -->
                ${
                  resume.languages.length !== 0
                    ? `
                <div class="skillSection">
                <div>Language</div>
                <div>
                  ${resume.languages
                    .map((p) => {
                      return `
                    <div class="skillItem">
                    <div>${p.language}</div>
                    <div style="width: ${p.level}%"></div>
                    </div>
                    `;
                    })
                    .join(" ")}
                </div>
                </div>
                `
                    : ""
                }
              </section>
            </div>
          </section>
        </body>
      </html>
    `;
}
