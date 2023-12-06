import { Resume, formatDate } from "../utils";

export default function generateResumeHTML(resume:Resume , timeZone: string){
    return `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0" />
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Rubik:wght@300;400;500;600&display=swap" />
    </head>
    <body>
        <section id="resume" class="resume"
        style="
        font-family: 'Rubik', sans-serif;
        width: 210mm;
        min-height: 297mm;
        background-color: darkblue;
        margin: 0 auto;
        display: flex;
        ">
         <div style="
         flex: 3;
         background-color: aliceblue;
         ">
            <!-- Left section  -->
            <div style="padding: 15px 0px; margin: 0px 20px; border-bottom: 2px solid gainsboro;">
                <!-- Profile section -->
                <div> <img style="width: 100px; height: 100px; border-radius: 50%;" src="${resume.profilePicture}" alt="" srcset=""> </div>
                <div style=" font-size: 1.5rem; font-weight: 600; margin: 10px 0px;">${resume.name}</div>
                <div style="font-size: 1.3rem; font-weight: 400; margin: 0px 0px 10px 0px">${resume.profession}</div>
                <div style="font-size: 0.87rem; font-weight: 400;">${resume.profile}</div>
            </div>
    
            <!-- Contact -->
            <div style="padding: 15px 0px; margin: 20px 20px 0px 20px; border-bottom: 2px solid gainsboro;">
                 <!-- Contact item -->
                 <!-- Email -->
                 <div style="display: flex; align-items: center; margin: 20px 0px;">
                    <div> <span style="padding: 5px;  border-radius: 50%; background-color: rgb(203, 203, 203); display: flex; align-items: center; justify-content: center;"><span class="material-symbols-outlined" style="font-size: 1.3rem;color:rgb(77, 76, 76);"> mail </span></span> </div>
                    <div style="padding-left: 10px;">
                        <div style="font-size: 0.75rem; color: rgb(54, 54, 54); font-weight: 400;">Email</div>
                        <div style="font-size: 0.85rem; font-weight: 400;margin-top: 3px;"> ${resume.details.email} </div>
                    </div>
                 </div>
    
                
                 <!-- Phone -->
                 <div style="display: flex; align-items: center; margin: 20px 0px;">
                    <div> <span style="padding: 5px;  border-radius: 50%; background-color: rgb(203, 203, 203); display: flex; align-items: center; justify-content: center;"><span class="material-symbols-outlined" style="font-size: 1.3rem;color:rgb(77, 76, 76);"> call </span></span> </div>
                    <div style="padding-left: 10px;">
                        <div style="font-size: 0.75rem; color: rgb(54, 54, 54); font-weight: 400;">Phone</div>
                        <div style="font-size: 0.85rem; font-weight: 400;margin-top: 3px;"> ${resume.details.phone} </div>
                    </div>
                 </div>
                   
                 <!-- Address -->
                 <div style="display: flex; align-items: center; margin: 20px 0px;">
                    <div> <span style="padding: 5px;  border-radius: 50%; background-color: rgb(203, 203, 203); display: flex; align-items: center; justify-content: center;"><span class="material-symbols-outlined" style="font-size: 1.3rem;color:rgb(77, 76, 76);"> map </span></span> </div>
                    <div style="padding-left: 10px;">
                        <div style="font-size: 0.75rem; color: rgb(54, 54, 54); font-weight: 400;">Address</div>
                        <div style="font-size: 0.85rem; font-weight: 400;margin-top: 3px;"> ${resume.details.address} , ${resume.details.city} -  ${resume.details.postalCode}, ${resume.details.country} </div>
                    </div>
                 </div>
            </div>
            
            <!-- Links  -->
            <div style="padding: 15px 0px; margin: 20px 20px 0px 20px; border-bottom: 2px solid gainsboro;">   
                    <div style="font-size: 0.75rem; color: rgb(54, 54, 54); font-weight: 400;">Links</div>
    
                    <!-- Link item -->
                    ${
                        resume.links.map((link) => {
                            return `
                            <div style="display: flex; align-items: center; margin: 20px 0px;">
                                <div> <span style="padding: 0px;  border-radius: 50%; background-color: rgb(203, 203, 203); display: flex; align-items: center; justify-content: center;"><img style="width: 30px; height: 30px;" src="https://th.bing.com/th/id/OIP.5CztuplBGWWYSG9tbbktTAHaHa?rs=1&pid=ImgDetMain" alt="" srcset=""></span> </div>
                                <div style="padding-left: 10px;">
                                    <div style="font-size: 0.75rem; color: rgb(54, 54, 54); font-weight: 400;">${link.title}</div>
                                    <div style="font-size: 0.85rem; font-weight: 400;margin-top: 3px;">${link.url} </div>
                                </div>
                            </div>
                            `
                        }).join(" ")
                    }
            </div>
    
            <!-- Languages -->
            <div style="padding: 15px 0px; margin: 20px 20px 0px 20px; border-bottom: 2px solid gainsboro;">   
                <div style="font-size: 0.75rem; color: rgb(54, 54, 54); font-weight: 400;">Languages</div>
                
                ${
                    resume.languages.map((language) => {
                        return `
                        <div style="display: flex; align-items: center; margin: 20px 0px;">
                            <div> <span style="padding: 0px;  border-radius: 50%; background-color: rgb(203, 203, 203); display: flex; align-items: center; justify-content: center;"><img style="width: 30px; height: 30px; border-radius: 50%;" src="https://play-lh.googleusercontent.com/Wr0wXe9aAQlscR1e-iUejChvdit9N2n7p807quJL-A1_zxyc5-0q0hNiBl8e_S3f4wY" alt="" srcset=""></span> </div>
                            <div style="padding-left: 10px;">
                                <div style="font-size: 0.85rem; font-weight: 400;margin-top: 3px;">${language.language}</div>
                                <div style="font-size: 0.75rem; color: rgb(54, 54, 54); font-weight: 400;"> ${
                                    language.level > 90 ? "Native" : language.level > 60 ? "Fluent" : "Beginner"
                                } </div>
                            </div>
                        </div>
                        `
                    }).join(" ")
                }
            </div>
            
         </div>
         <div style="
         flex:5;
         background-color: white;
         padding: 10px 25px;
         ";
         >
         <!-- Right section -->
         
        <div >
            <!-- Experience -->
            <div style="font-size: 1.5rem; font-weight: 400;margin-bottom: 25px;">Experience</div>
            <!-- Experience item -->
                ${
                    resume.employmentHistory.map((exp) => {
                        return `
                        <div style="display: flex; align-items: center; margin: 20px 0px;background-color: aliceblue; padding:10px; margin:10px 0px; border-radius: 10px;">
                            <div><img style="width: 35px; height: 35px; margin-right: 15px;" src="https://toppng.com/uploads/preview/business-icon-establish-a-company-ico-11562937071dk415zbolw.png" alt="" srcset=""></div>
                            <div style="flex: 1;">
                                <div style="font-size: 0.8rem;font-weight: 400; color:rgb(70, 70, 70)"> ${exp.job} </div>
                                <div style="font-size: 1rem; font-weight: 500;">${exp.employer}</div>
                            </div>
                            <div>
                                <div style="font-size: 0.8rem;">${formatDate(exp.startDate, timeZone)} -- ${formatDate(exp.endDate, timeZone)}</div>
                                <div style="font-size: 0.7rem;margin-top: 5px;">${exp.city}</div>
                            </div>
                        </div>
                        `
                    }).join(" ")
                }
        </div>
    
         <!-- Skills  -->
         <div style="margin: 30px 0px;">
            <!-- Skill header -->
            <div style="font-size: 1.5rem; font-weight: 400;margin-bottom: 25px;">Skills</div>
            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr;grid-gap: 20px;">
                <!-- list all skills items -->
                ${
                    resume.skills.map((skill) => {
                        return `<div style="width: 100px; height: 70px; font-size: 0.86rem; font-weight: 500; background-color: aliceblue; text-align: center; display: flex; align-items: center; justify-content: center; padding: 10px;">${skill.skill}</div>`
                    }).join(" ")
                }
            </div>
         </div>
    
         <!-- Internship -->
         <div>
            <!-- Internship -->
            <div style="font-size: 1.5rem; font-weight: 400;margin-bottom: 25px;">Internship</div>
            
            <!-- Internship item -->
            ${
                resume.internship.map((internship) => {
                    return `
                    <div style="display: flex; align-items: center; margin: 20px 0px;background-color: aliceblue; padding:10px; margin:10px 0px; border-radius: 10px;">
                        <div><img style="width: 35px; height: 35px; margin-right: 15px;" src="https://toppng.com/uploads/preview/business-icon-establish-a-company-ico-11562937071dk415zbolw.png" alt="" srcset=""></div>
                        <div style="flex: 1;">
                            <div style="font-size: 0.8rem;font-weight: 400; color:rgb(70, 70, 70)"> ${internship.job} </div>
                            <div style="font-size: 1rem; font-weight: 500;">${internship.employer}</div>
                        </div>
                        <div>
                            <div style="font-size: 0.8rem;">${formatDate(internship.startDate, timeZone)} -- ${formatDate(internship.endDate, timeZone)}</div>
                            <div style="font-size: 0.7rem;margin-top: 5px;">${internship.city}</div>
                        </div>
                    </div>
                    `
                }).join(" ")
            }    
         </div>
    
         <!-- Education -->
        <div style="margin: 25px 0px;">
            <!-- Education -->
            <div style="font-size: 1.5rem; font-weight: 400;margin-bottom: 25px;">Education</div>
    
            <!-- Education item -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                ${
                    resume.education.map((edu) => {
                        return `
                        <div style="background-color: aliceblue; padding: 10px;">
                            <div style="display: flex; align-items: center; ">
                                <div><img style="width: 45px; height: 45px;" src="https://toppng.com/public/uploads/preview/icons-education-education-icon-purple-11553430165fbcetvy8ll.png" alt="" srcset=""></div>
                                <div style="margin-left: 10px;font-size: 0.85rem; font-weight: 400;">${edu.school}</div>
                            </div>
                            <div style="margin-top: 10px;">
                                <div style="font-size: 0.89rem; font-weight: 500;">${edu.degree}</div>
                                <div style="font-size: 0.75rem; color: rgb(77, 77, 77); font-weight: 400;margin-top: 5px;">${formatDate(edu.startDate, timeZone)} -- ${formatDate(edu.endDate, timeZone)}</div>
                            </div>
                        </div>
                        `
                    }).join(" ")
                }
            </div>
        </div>
    
        <!-- Hobbies -->
        <div>
            <div style="font-size: 1.5rem; font-weight: 400;margin-bottom: 25px;">Hobbies</div>
            <div>${ resume.hobbies}</div>
        </div>
    
        <!-- Courses -->
        <div style="margin: 25px 0px;">
            <!-- Education -->
            <div style="font-size: 1.5rem; font-weight: 400;margin-bottom: 25px;">Courses</div>
    
            <!-- Education item -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                ${
                    resume.courses.map((course) => {
                        return `
                        <div style="background-color: aliceblue; padding: 10px;">
                            <div style="display: flex; align-items: center; ">
                                <div><img style="width: 45px; height: 45px;" src="https://icon-library.com/images/courses-icon/courses-icon-27.jpg" alt="" srcset=""></div>
                                <div style="margin-left: 10px;font-size: 0.85rem; font-weight: 400;">${course.course}</div>
                            </div>
                            <div style="margin-top: 10px;">
                                <div style="font-size: 0.89rem; font-weight: 500;">${course.institution}</div>
                                <div style="font-size: 0.75rem; color: rgb(77, 77, 77); font-weight: 400;margin-top: 5px;">${formatDate(course.startDate, timeZone)} -- ${formatDate(course.endDate, timeZone)}</div>
                            </div>
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