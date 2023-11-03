import { Resume, formatDate } from "../utils";

export default function generateResumeHTML(resume:Resume ){
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
    <section id="resume" class="resume" style="
        font-family: 'Rubik', sans-serif;
        width: 210mm;
        min-height: 297mm;
        margin: 0 auto;
        background-color: white;
        border: 1px solid gainsboro;
        display: flex;
        align-items: center;
        padding: 0px;
        position: relative;
        display: flex;
        align-items: flex-start;
        ">
         <div style="flex: 2.5;background-color: white;">
            <div style="padding: 15px; display: flex; flex-direction: column; align-items: center;"> <img style="width: 150px; height: 150px;border-radius: 5%;" src="https://www.w3schools.com/howto/img_avatar.png" alt="" srcset=""> </div>
            <div style="padding: 10px; margin-bottom: 15px; margin-top: 0px">
                <div style="border-bottom: 0px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Personal Details</div>
                <div style="display: ${resume.details.email ? 'flex' : 'none'}; align-items: flex-start; font-size: 0.8rem; padding: 5px; margin-bottom: 2px">
                  <span class="material-symbols-outlined" style="margin-right: 10px; font-size: 0.9rem"> email </span>  ${resume.details.email}
                </div>
                <div style="display: ${resume.details.phone ? 'flex' : 'none'}; align-items: flex-start; font-size: 0.8rem; padding: 5px; margin-bottom: 2px">
                  <span class="material-symbols-outlined" style="margin-right: 10px; font-size: 0.9rem"> phone </span> ${resume.details.phone}
                </div>
                <div style="display: ${resume.details.address ? 'flex' : 'none'}; align-items: flex-start; font-size: 0.8rem; padding: 5px; margin-bottom: 2px">
                  <span class="material-symbols-outlined" style="margin-right: 10px; font-size: 0.9rem"> home </span> ${resume.details.address} , ${resume.details.city} -  ${resume.details.postalCode}, ${resume.details.country}
                </div>
              </div>
  
              <!-- place of birth -->
              <div style="padding: 10px; margin-bottom: 15px; display: ${resume.details.placeOfBirth || resume.details.dateOfBirth ? 'block' : 'none'}">
                <div style="border-bottom: 0px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Date/place of birth</div>
                <div style="display: flex; align-items: flex-start; font-size: 0.8rem; padding: 5px 5px 0px 5px; margin-bottom: 0px">${formatDate(resume.details.dateOfBirth)}</div>
                <div style="display: flex; align-items: flex-start; font-size: 0.8rem; padding: 5px; margin-bottom: 0px">${resume.details.placeOfBirth}</div>
              </div>
  
              <!-- Driving license -->
              <div style="padding: 10px; margin-bottom: 15px; display: ${resume.details.drivingLicense ? 'block' : 'none'}">
                <div style="border-bottom: 0px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Driving License</div>
                <div style="display: flex; align-items: flex-start; font-size: 0.8rem; padding: 5px 5px 0px 5px; margin-bottom: 0px">${resume.details.drivingLicense}</div>
              </div>
  
              <!-- Links -->
              <div style="padding: 10px; margin-bottom: 15px; display: ${resume.links.length ? 'block' : 'none'}">
                <div style="border-bottom: 0px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Links</div>
                ${
                    resume.links.map((p)=>{
                        return `
                        <div style="display: flex; align-items: flex-start; font-size: 0.8rem; padding: 5px 5px 0px 5px; margin-bottom: 0px">
                            <span class="material-symbols-outlined" style="margin-right: 10px; font-size: 0.9rem"> link </span> <a href="${p.url}">${p.title}</a>
                        </div>
                        `
                    }).join(" ")
                }
              </div>
  
              <!-- skills -->
              <div style="padding: 10px; margin-bottom: 15px; display: ${resume.skills.length ? 'block' : 'none'}">
                <div style="border-bottom: 0px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Skills</div>
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
                <div style="border-bottom: 0px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Hobbies</div>
                <div style="font-size: 0.8rem; padding: 5px">
                  ${resume.hobbies}
                </div>
              </div>
  
              <!-- Languages -->
              <div style="padding: 10px; margin-bottom: 15px; display: ${resume.languages.length ? 'block' : 'none'}">
                <div style="border-bottom: 0px solid gainsboro; font-size: 1rem; padding: 5px; margin-bottom: 10px">Languages</div>
                <!-- List all the languages -->
                ${
                    resume.languages.map((p)=> {
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
         <div style="flex: 5;background-color: #ffddc3; min-height:297mm;">
              <div style="display: flex; flex-direction: column;align-items: center;">
                <div style="font-size: 1.25rem; margin-top: 15px; text-transform: uppercase; font-weight: 600">${resume.name}</div>
                <div style="font-size: 1.1rem; font-weight: 400; margin-top: 15px; letter-spacing: 0.8rem">${resume.profession}</div>
                <div style="font-size: 0.9rem; font-weight: 400; margin-top: 25px; color: rgb(88, 88, 88); padding: 0px 20px; text-align: center">
                  ${resume.profile}
                </div>
              </div>

              <!-- employment history -->
            <div style="display: ${resume.employmentHistory.length ? 'flex' : 'none'}; align-items: flex-start; padding: 15px 10px;margin-top: 25px;">
                <div><span class="material-symbols-outlined" style="margin-right: 15px; font-size: 1.5rem"> work </span></div>
                <div>
                  <div style="font-size: 1rem; font-weight: 600; margin-bottom: 10px; padding: 3px">Employment History</div>
                  <!-- list all employment history -->
                  ${
                    resume.employmentHistory.map((p)=>{
                        return `
                        <div style="margin: 0px 0px 20px 0px">
                            <div style="font-size: 0.85rem; font-weight: 500">${p.job} at ${p.employer} , ${p.city}</div>
                            <div style="font-size: 0.85rem; font-weight: 400; margin: 10px 0px; color: rgb(70, 70, 70)">${formatDate(p.startDate)} -- ${formatDate(p.endDate)}</div>
                            <div style="font-size: 0.8rem">${p.description}</div>
                        </div>
                        `
                    }).join(" ")
                  }
                </div>
              </div>
  
              <!-- Educations -->
              <div style="display: ${resume.education.length ? 'flex' : 'none'}; align-items: flex-start; padding: 15px 10px">
                <div><span class="material-symbols-outlined" style="margin-right: 15px; font-size: 1.5rem"> school </span></div>
                <div>
                  <div style="font-size: 1rem; font-weight: 600; margin-bottom: 10px;  padding: 3px">Education</div>
                  <!-- list all employment history -->
                  ${
                    resume.education.map((p)=>{
                        return `
                        <div style="margin: 0px 0px 20px 0px">
                            <div style="font-size: 0.85rem; font-weight: 500">${p.degree} at ${p.school} , ${p.city}</div>
                            <div style="font-size: 0.85rem; font-weight: 400; margin: 10px 0px; color: rgb(70, 70, 70)">${formatDate(p.startDate)} -- ${formatDate(p.endDate)}</div>
                        </div>
                        `
                    }).join(" ")
                  }
                </div>
              </div>
  
              <!-- Internship -->
              <div style="display: ${resume.internship.length ? 'flex' : 'none'}; align-items: flex-start; padding: 15px 10px">
                <div><span class="material-symbols-outlined" style="margin-right: 15px; font-size: 1.5rem"> people </span></div>
                <div>
                  <div style="font-size: 1rem; font-weight: 600; margin-bottom: 10px;  padding: 3px">Internship</div>
                  <!-- list all employment history -->
                  ${
                    resume.internship.map((p)=> {
                        return `
                        <div style="margin: 0px 0px 20px 0px">
                            <div style="font-size: 0.85rem; font-weight: 500">${p.job} at ${p.employer} , ${p.city}</div>
                            <div style="font-size: 0.85rem; font-weight: 400; margin: 10px 0px; color: rgb(70, 70, 70)">${formatDate(p.startDate)} -- ${formatDate(p.endDate)}</div>
                            <div style="font-size: 0.8rem">${p.description}</div>
                        </div>
                        `
                    }).join(" ")
                  }
                </div>
              </div>
  
              <!-- Courses -->
              <div style="display: ${resume.courses.length ? 'flex' : 'none'}; align-items: flex-start; padding: 15px 10px">
                <div><span class="material-symbols-outlined" style="margin-right: 15px; font-size: 1.5rem"> book </span></div>
                <div>
                  <div style="font-size: 1rem; font-weight: 600; margin-bottom: 10px;  padding: 3px">Courses</div>
                  <!-- list all employment history -->
                  ${
                    resume.courses.map((p)=>{
                        return `
                        <div style="margin: 0px 0px 20px 0px">
                            <div style="font-size: 0.85rem; font-weight: 500">${p.course}, ${p.institution}</div>
                            <div style="font-size: 0.85rem; font-weight: 400; margin: 10px 0px; color: rgb(70, 70, 70)">${formatDate(p.startDate)} -- ${formatDate(p.endDate)}</div>
                        </div>
                        `
                    }).join(" ")
                  }
                </div>
              </div>
         </div>
        </section>
  </body>
</html>
    `
}