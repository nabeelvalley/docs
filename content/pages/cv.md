---
title: CV
layout: none
---

<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charSet="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/x-icon" href="/favicon.png">
  <link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:wght@300&family=Lato:wght@300;400&display=swap"
    rel="stylesheet">
  <title>Nabeel Valley - CV</title>
  <style>
    @import"https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&display=swap";
    @import"https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@400;600&family=Inconsolata:ital,wght@0,400;0,600;1,400;1,600&display=swap";

    html,
    body {
      background-color: #000;
      font-family: Open Sans;
      font-optical-sizing: auto;
      font-style: normal;
      font-size: 12px;
      margin: 0
    }

    main {
      color: #09001a;
      --color-1: hsl(260deg 100% 40%);
      --color-2: hsl(260deg 100% 98%);
      margin: auto;
      background-color: #fff;
      display: flex;
      flex-direction: row;
      gap: 16px;
      height: 297mm;
      width: 210mm;
      box-sizing: border-box;
      padding: 32px;

      p,
      h3 {
        margin-top: 8px
      }

      * {
        margin: 0;
        padding: 0;
        text-decoration: none
      }

      hr {
        border: none;
        border-top: 1px var(--color-1) solid
      }

      h2 {
        color: var(--color-1)
      }

      .timeline {
        flex: 2;
        display: flex;
        flex-direction: column;

        hr {
          margin: 32px 0 16px
        }

        .location {
          display: flex;
          flex-direction: row;
          align-items: center;
          gap: 8px
        }

        .summary {
          color: var(--color-1);
          display: flex;
          flex-direction: row;
          justify-content: space-between;
          margin-top: 4px;

          p {
            margin: 0
          }
        }

        experiences {
          display: flex;
          flex-direction: column;
          gap: 8px
        }

        educations {
          display: flex;
          flex-direction: row;
          gap: 16px;

          item {
            flex: 1
          }
        }
      }

      a {
        color: var(--color-1)
      }

      li {
        margin-left: 12px;

        &::marker {
          color: var(--color-1)
        }
      }

      svg {
        display: block;
        height: 12px;
        width: 12px
      }

      .intro {
        background-color: var(--color-2);
        flex: 1;
        padding: 16px;
        display: flex;
        flex-direction: column;
        gap: 8px;

        tagline {
          font-size: 1.2rem
        }

        hr {
          margin: 12px 0
        }

        .skills {
          list-style-type: "# ";
          display: flex;
          flex-wrap: wrap
        }

        .contact {
          list-style: none;

          li {
            margin-left: 0;

            a {
              display: flex;
              flex-direction: row;
              align-items: center;
              gap: 8px
            }
          }
        }
      }
    }
  </style>
</head>

<body >
  <main >
    <section class="intro" >
      <h1 >Nabeel Valley</h1>
      <tagline >Software Engineer</tagline>
      <hr >
      <h2 >About me</h2>
      <div class="about" >
        <p >My name is Nabeel Valley, I&#39;m from South Africa and have been living in the
          Netherlands since 2023</p>
        <p >I have a Bachelor&#39;s of Engineering in Mechanical Engineering and have worked
          professionally as a Software Engineer since 2018</p>
        <p >My hobbies include building little apps, graphic and ui design, photography, and
          skateboarding</p>
        <p ></p>
      </div>
      <h3 >Contact</h3>
      <ul class="contact" role="list" > <!-- icons from feathericons.com -->
        <li > <a href="tel:+31 6 45 97 07 34" > <svg role="image"
              aria-labelledby="phone" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
              fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
              class="feather feather-phone" >
              <path
                d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"
                ></path>
            </svg> +31 6 45 97 07 34 </a> </li>
        <li > <a href="mailto:nabeelvalley@outlook.com" > <svg
              role="image" aria-labelledby="email" xmlns="http://www.w3.org/2000/svg" width="24" height="24"
              viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
              stroke-linejoin="round" class="feather feather-mail" >
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"
                ></path>
              <polyline points="22,6 12,13 2,6" ></polyline>
            </svg> nabeelvalley@outlook.com </a> </li>
        <li > <a href="https://www.linkedin.com/in/nabeelvalley/" > <svg
              role="image" aria-labelledby="linkedin" xmlns="http://www.w3.org/2000/svg" width="24" height="24"
              viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
              stroke-linejoin="round" class="feather feather-linkedin" >
              <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"
                ></path>
              <rect x="2" y="9" width="4" height="12" ></rect>
              <circle cx="4" cy="4" r="2" ></circle>
            </svg>
            linkedin.com/in/nabeelvalley
          </a> </li>
        <li > <a href="https://nabeelvalley.co.za" > <svg role="image"
              aria-labelledby="website" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
              fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
              class="feather feather-globe" >
              <circle cx="12" cy="12" r="10" ></circle>
              <line x1="2" y1="12" x2="22" y2="12" ></line>
              <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"
                ></path>
            </svg>
            nabeelvalley.co.za
          </a> </li>
      </ul>
      <h3 >Languages</h3>
      <ul role="list" class="languages" >
        <li >English (<b >Native</b>)</li>
        <li >Dutch (<b >B2</b>)</li>
        <li >Afrikaans</li>
      </ul>
      <h3 >Certifications</h3>
      <ul role="list" >
        <li >AWS Developer Associate</li>
        <li >AWS Cloud Practitioner</li>
        <li >Enterprise Design Thinking</li>
      </ul>
      <h3 >Skills</h3>
      <ul role="list" class="skills" >
        <li >Angular</li>
        <li >AWS</li>
        <li >Azure</li>
        <li >C#</li>
        <li >CI/CD</li>
        <li >Containers</li>
        <li >CSS</li>
        <li >DevOps</li>
        <li >Docker</li>
        <li >GitHub</li>
        <li >Golang</li>
        <li >HTML</li>
        <li >Javascript</li>
        <li >Machine Learning</li>
        <li >Microservices</li>
        <li >Monorepo</li>
        <li >Node.js</li>
        <li >Nx</li>
        <li >React</li>
        <li >Rust</li>
        <li >Turbo</li>
        <li >Typescript</li>
        <li >Web Accessibility</li>
      </ul>
    </section>
    <section class="timeline" >
      <h2 >Experience</h2>
      <experiences >
        <h3 class="title" >Entelect</h3>
        <h4 class="subtitle" >Senior Software Engineer / Platform Engineer</h4>
        <div class="summary" >
          <p class="period" >July 2023 - present</p>
          <p class="location" > Amsterdam/Utrecht, Netherlands <svg
              xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
              class="feather feather-map-pin" >
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" ></path>
              <circle cx="12" cy="10" r="3" ></circle>
            </svg> </p>
        </div>
        <ul class="description" >
          <li >Senior Software Engineer and Platform Engineer for the web ecosystem</li>
          <li >Finding ways to make developers in the organization more productive</li>
          <li >Creation of tools to simplify development tasks or automations to speed up
            migrations or updates across large codebases</li>
          <li >Developer enablement on Web Accessibility topics</li>
          <li >Participation and management of programmes to enable developers to learn and share
            knowledge at various different levels within Entelect and customer organizations</li>
          <li >Primarily using Typescript, JavaScript, Angular, Nx, Web Components, and Go along
            with Azure DevOps</li>
        </ul>
        <h3 class="title" >Quro Medical</h3>
        <h4 class="subtitle" >Senior Software Engineer</h4>
        <div class="summary" >
          <p class="period" >May 2021 - July 2023</p>
          <p class="location" > Johannesburg, South Africa <svg
              xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
              class="feather feather-map-pin" >
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" ></path>
              <circle cx="12" cy="10" r="3" ></circle>
            </svg> </p>
        </div>
        <ul class="description" >
          <li >Focused on developing cross-platform applications with React-Native and Typescript
          </li>
          <li >Building scalable, cloud-native IoT and healthcare solutions on AWS and GCP</li>
          <li >Developing and managing machine learning models</li>
          <li >Working with and up-skilling junior developers</li>
          <li >Interacting with business to define solutions to healthcare and technical
            challenges</li>
        </ul>
        <h3 class="title" >Mercedes-Benz</h3>
        <h4 class="subtitle" >Web Developer / Technical Specialist</h4>
        <div class="summary" >
          <p class="period" >March 2019 - April 2021</p>
          <p class="location" > Pretoria, South Africa <svg xmlns="http://www.w3.org/2000/svg"
              width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round" class="feather feather-map-pin" >
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" ></path>
              <circle cx="12" cy="10" r="3" ></circle>
            </svg> </p>
        </div>
        <ul class="description" >
          <li >Full stack web developer in the marketing/customer data analytics team focused on
            end-to-end delivery of software projects</li>
          <li >Optimizing customer experiences on web platforms and integrating with a variety
            1st and 3rd party applications and supporting with data related operations</li>
          <li >Using Agile methodologies to delivering software in a three tier, service-oriented
            architecture</li>
          <li >Primarily using .NET, Node.js, React, and Jenkins</li>
        </ul>
        <h3 class="title" >IBM</h3>
        <h4 class="subtitle" >Cloud Developer Advocate, Graduate</h4>
        <div class="summary" >
          <p class="period" >September 2018 - February 2019</p>
          <p class="location" > Johannesburg, South Africa <svg
              xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
              class="feather feather-map-pin" >
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" ></path>
              <circle cx="12" cy="10" r="3" ></circle>
            </svg> </p>
        </div>
        <h3 class="title" >Microsoft</h3>
        <h4 class="subtitle" >Full Stack Web Developer, Intern</h4>
        <div class="summary" >
          <p class="period" >February 2018 - August 2018</p>
          <p class="location" > Johannesburg, South Africa <svg
              xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
              class="feather feather-map-pin" >
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" ></path>
              <circle cx="12" cy="10" r="3" ></circle>
            </svg> </p>
        </div>
      </experiences>
      <hr >
      <h2 >Education</h2>
      <educations >
        <item >
          <h3 class="title" >University of Pretoria</h3>
          <h4 class="subtitle" >BEng(Mechanical Engineering)</h4>
          <p class="summary" >January 2014 - December 2017</p>
        </item>
        <item >
          <h3 class="title" >Al Ghazali College</h3>
          <h4 class="subtitle" >National Senior Certificate</h4>
          <p class="summary" >December 2013</p>
        </item>
      </educations>
    </section>
  </main>
</body>

</html>
