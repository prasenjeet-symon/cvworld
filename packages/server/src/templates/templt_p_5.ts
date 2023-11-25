import { Resume, formatDate } from "../utils";

export default function generateResumeHTML(resume:Resume , timeZone: string){
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
    </style>
  </head>
  <body>
    <section id="resume" class="resume"
      style="
        font-family: 'Rubik', sans-serif;
        width: 210mm;
        min-height: 297mm;
        margin: 0 auto;
        background-color: white;
        display: flex;
        align-items: flex-start;
        justify-content: center;
        position: relative;
      "
    >
      <!-- floating personal details  -->
      <div style="position: absolute; top: 20px; background-color: #c4749d; width: 80%; border: 10px solid white; padding: 10px; color: white">
        <div style="font-size: 1.5rem; font-weight: 600; padding: 5px; margin-bottom: 10px; display: ${resume.name ? 'block' : 'none'}">${resume.name}</div>
        <div>
          <div style="display: ${resume.details.email ? 'flex' : 'none'}; align-items: flex-start; font-size: 0.8rem; padding: 5px; margin-bottom: 2px">
            <span class="material-symbols-outlined" style="margin-right: 10px; font-size: 0.9rem"> email </span> ${resume.details.email}
          </div>
          <div style="display: ${resume.details.phone ? 'flex' : 'none'}; align-items: flex-start; font-size: 0.8rem; padding: 5px; margin-bottom: 2px">
            <span class="material-symbols-outlined" style="margin-right: 10px; font-size: 0.9rem"> phone </span> ${resume.details.phone}
          </div>
          <div style="display: ${resume.details.address ? 'flex' : 'none'}; align-items: flex-start; font-size: 0.8rem; padding: 5px; margin-bottom: 2px">
            <span class="material-symbols-outlined" style="margin-right: 10px; font-size: 0.9rem"> home </span>${resume.details.address} , ${resume.details.city} -  ${resume.details.postalCode}, ${resume.details.country}
          </div>
        </div>
      </div>
      <div style="flex: 2.45; min-height: 297mm; background-color: #282831; color: white; padding: 200px 0px 0px 0px">
        <!-- place of birth -->
        <div style="padding: 10px; margin-bottom: 15px; display: ${resume.details.placeOfBirth || resume.details.dateOfBirth ? 'block' : 'none'}">
          <div style="border-bottom: 1px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Date/place of birth</div>
          <div style="display: flex; align-items: flex-start; font-size: 0.8rem; padding: 5px 5px 0px 5px; margin-bottom: 0px">${formatDate(resume.details.dateOfBirth, timeZone)}</div>
          <div style="display: flex; align-items: flex-start; font-size: 0.8rem; padding: 5px; margin-bottom: 0px">${resume.details.placeOfBirth}</div>
        </div>

        <!-- Driving license -->
        <div style="padding: 10px; margin-bottom: 15px; display: ${resume.details.drivingLicense ? 'block' : 'none'}">
          <div style="border-bottom: 1px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Driving License</div>
          <div style="display: flex; align-items: flex-start; font-size: 0.8rem; padding: 5px 5px 0px 5px; margin-bottom: 0px">${resume.details.drivingLicense}</div>
        </div>

        <!-- Links -->
        <div style="padding: 10px; margin-bottom: 15px; display: ${resume.links.length > 0 ? 'block' : 'none'}">
          <div style="border-bottom: 1px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Links</div>
          ${
            resume.links.map((p)=>{
                return `
                <div style="display: flex; align-items: flex-start; font-size: 0.8rem; padding: 5px 5px 0px 5px; margin-bottom: 0px">
                    <span class="material-symbols-outlined" style="margin-right: 10px; font-size: 0.9rem"> link </span>
                    <a style="color: white" href="${p.url}">${p.title}</a>
                </div>
                `
            }).join(" ")
          }
        </div>

        <!-- skills -->
        <div style="padding: 10px; margin-bottom: 15px; display: ${resume.skills.length > 0 ? 'block' : 'none'}">
          <div style="border-bottom: 1px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Skills</div>
          <!-- list all the skills -->
          ${
            resume.skills.map((p)=>{
                return `
                <div style="font-size: 0.8rem; padding: 5px 5px 0px 5px; margin-bottom: 5px">
                    <div>${p.skill}</div>
                    <div style="width: ${p.level}%; background-color: salmon; height: 5px; margin-top: 3px"></div>
                </div>
                `
            }).join(" ")
          }
        </div>

        <!-- Hobbies -->
        <div style="padding: 10px; margin-bottom: 15px; display: ${resume.hobbies ? 'block' : 'none'}">
          <div style="border-bottom: 1px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Hobbies</div>
          <div style="font-size: 0.8rem; padding: 5px">
            ${resume.hobbies}
          </div>
        </div>

        <!-- Languages -->
        <div style="padding: 10px; margin-bottom: 15px; display: ${resume.languages.length > 0 ? 'block' : 'none'}">
          <div style="border-bottom: 1px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Languages</div>
          <!-- List all the languages -->
          ${
            resume.languages.map((p)=>{
                return `
                <div style="font-size: 0.8rem; padding: 5px 5px 0px 5px; margin-bottom: 5px">
                    <div>${p.language}</div>
                    <div style="width: ${p.level}%; background-color: salmon; height: 5px; margin-top: 3px"></div>
                </div>
                `
            }).join(" ")
          }
        </div>
      </div>
      <div style="flex: 5; height: 100%; background-color: white; padding: 200px 0px 0px 0px;">
        <!-- Profile -->
        <div style="display: ${resume.profile ? 'flex' : 'none'}; align-items: flex-start; padding: 10px 10px">
          <div><span class="material-symbols-outlined" style="margin-right: 15px; font-size: 1.5rem"> person </span></div>
          <div>
            <div style="font-size: 1rem; font-weight: 600; margin-bottom: 10px; background-color: #c4749d; color: white; padding: 2px 5px; display: inline-block;">Profile</div>
            <div style="font-size: 0.9rem; font-weight: 400; line-height: 1.25rem">
              ${resume.profile}
            </div>
          </div>
        </div>

        <!-- employment history -->
        <div style="display: ${resume.employmentHistory.length > 0 ? 'flex' : 'none'}; align-items: flex-start; padding: 15px 10px">
          <div><span class="material-symbols-outlined" style="margin-right: 15px; font-size: 1.5rem"> work </span></div>
          <div>
            <div style="font-size: 1rem; font-weight: 600; margin-bottom: 10px; background-color: #c4749d; color: white; padding: 2px 5px; display: inline-block;">Employment History</div>
            <!-- list all employment history -->
            ${
                resume.employmentHistory.map((p)=>{
                    return `
                    <div style="margin: 0px 0px 20px 0px">
                        <div style="font-size: 0.85rem; font-weight: 500">${p.job} at ${p.employer} , ${p.city}</div>
                        <div style="font-size: 0.85rem; font-weight: 400; margin: 10px 0px; color: rgb(70, 70, 70)">${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                        <div style="font-size: 0.8rem">${p.description}</div>
                    </div>
                    `
                }).join(" ")
            }
          </div>
        </div>

        <!-- Educations -->
        <div style="display: ${resume.education.length > 0 ? 'flex' : 'none'}; align-items: flex-start; padding: 15px 10px;">
          <div><span class="material-symbols-outlined" style="margin-right: 15px; font-size: 1.5rem"> school </span></div>
          <div>
            <div style="font-size: 1rem; font-weight: 600; margin-bottom: 10px; background-color: #c4749d; color: white; padding: 2px 5px; display: inline-block;">Education</div>
            <!-- list all employment history -->
            ${
                resume.education.map((p)=>{
                    return `
                    <div style="margin: 0px 0px 20px 0px">
                        <div style="font-size: 0.85rem; font-weight: 500">${p.degree} at ${p.school} , ${p.city}</div>
                        <div style="font-size: 0.85rem; font-weight: 400; margin: 10px 0px; color: rgb(70, 70, 70)">${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                    </div>
                    `
                }).join(" ")
            }
          </div>
        </div>

        <!-- Internship -->
        <div style="display: ${resume.internship.length > 0 ? 'flex' : 'none'}; align-items: flex-start; padding: 15px 10px">
          <div><span class="material-symbols-outlined" style="margin-right: 15px; font-size: 1.5rem"> people </span></div>
          <div>
            <div style="font-size: 1rem; font-weight: 600; margin-bottom: 10px; background-color: #c4749d; color: white; padding: 2px 5px; display: inline-block;">Internship</div>
            <!-- list all employment history -->
            ${
                resume.internship.map((p)=>{
                    return `
                    <div style="margin: 0px 0px 20px 0px">
                        <div style="font-size: 0.85rem; font-weight: 500">${p.job} at ${p.employer} , ${p.city}</div>
                        <div style="font-size: 0.85rem; font-weight: 400; margin: 10px 0px; color: rgb(70, 70, 70)">${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                        <div style="font-size: 0.8rem">${p.description}</div>
                    </div>
                    `
                }).join(" ")
            }
          </div>
        </div>

        <!-- Courses -->
        <div style="display: ${resume.courses.length > 0 ? 'flex' : 'none'}; align-items: flex-start; padding: 15px 10px">
          <div><span class="material-symbols-outlined" style="margin-right: 15px; font-size: 1.5rem"> book </span></div>
          <div>
            <div style="font-size: 1rem; font-weight: 600; margin-bottom: 10px; background-color: #c4749d; color: white; padding: 2px 5px; display: inline-block;">Courses</div>
            <!-- list all employment history -->
            ${
                resume.courses.map((p)=>{
                    return `
                    <div style="margin: 0px 0px 20px 0px">
                        <div style="font-size: 0.85rem; font-weight: 500">${p.course}, ${p.institution}</div>
                        <div style="font-size: 0.85rem; font-weight: 400; margin: 10px 0px; color: rgb(70, 70, 70)">${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                    </div>
                    `
                }).join(" ")
            }
          </div>
        </div>
      </div>
      <div></div>
    </section>
  </body>
</html>
    `;
}