<p align="left" width="100%">
  <img height="56" src="img/logo-ait.png"> &nbsp; &nbsp;
  <img height="56" src="img/eth-sip-3l.png">     
</p>

# Flex Studio, Group 1

#### Kai Zheng, Cashen Adkins, Tim Kluser, Karl Robert Kristenprun, Alexander Zank

## Project description

    TODO

Introduction to chosen topic in own words, possibly with a brief motivation

## Ideation & Evaluation

### Desk Research

Having selected "Cartoon" as our project topic, we first tried to find cartoon artists to give us some insight into their workflow and what they would like to see improved. Sadly, none of our posts on Reddit, nor E-Mails to cartoon networks, have been answered so far, so we relied on _existing conversations in creator lounges_, _existing applications in the field_, and on _blog posts_.

Before we entered the desk research, we already had some ideas of what we wanted to do, all revolving around a responsive cartoon-maker. But instead of following our initial ideas, desk research allowed us to see the abundance of flaws in the current workflow of cartoonists. It made us realize the scope of possibilities that we could pursue. Our sources indicate that webcomics are prone to die without innovation on both the creator and the consumer side. Artists often use general-purpose graphics software instead of specialized tools, and consumers seem to prefer more interactive content when consuming digital media.

### How-might-we's

With all of this in mind, we came up with our central questions:
How might we...

1. make it easier for beginners to learn drawing realistically?
2. help independent cartoonists grow their audience quickly?
3. reduce the idea-to-publication time in cartoon-drawing?
4. unify the overall workflow of cartoonists?
5. aid cartoonists in planning their story?

### Brainstorming

The 6-3-5 brainwriting technique was surprisingly effective at generating new ideas and expanding on our initial thoughts. The time limit and judgment-free environment resulted in a plethora of exciting ideas, many of which we would like to implement in our first prototypes.

We look forward to the prototyping phase, where we will explore different feature sets and interface elements.

## Low-fidelity Prototype

Our lo-fi prototyping happened in two stages: First, every member designed a very rough, 2D paper prototype showing their vision of one specific feature from our idea catalogue. After 30min, we had sketched

1. [a practice app with daily challenges](/Deliverables/LowFiPrototyping/Other/dlofi01.mov),
2. [a layer-based, responsive panel editor](/Deliverables/LowFiPrototyping/Other/dlofi02.mov),
3. [a side panel with references (from design inspiration over storyboards to character logs)](/Deliverables/LowFiPrototyping/Other/dlofi03.mov),
4. [an interactive 3D reference model concept](/Deliverables/LowFiPrototyping/Other/dlofi04.mov), and
5. [a library-esque navigation and unified export scheme](/Deliverables/LowFiPrototyping/Other/dlofi05.mov).

Half a week later, equipped with materials for handicrafts, we met again to build more sophisticated user storyboards and prototypes. We looked into how we could

1. [intuitively switch between 3D reference model joint adjustments and drawing mode](/Deliverables/LowFiPrototyping/IdeaA/),
2. [make navigating and exporting a breeze](/Deliverables/LowFiPrototyping/IdeaB/Storyboard.pdf), and
3. [leverage the layering concept to create a 3D parallax sensation when a reader tilts their device](/Deliverables/LowFiPrototyping/IdeaC/).

Prototyping was simple and fun. We noticed that some concepts, for instance the parallax viewer, previously had no consensus when it came to their execution. Playing around with a paper model made things clear for everyone.

We enter the next stage with excitement and plan to focus on these three core features. How we weigh them will be determined in the mid-fi prototypes.

## Mid-fidelity Prototype

To get a more thorough feeling for the structure, feature set, and visual language of our product, we decided to create pseudo-interactive prototypes for

1. the [top level-navigation](/Deliverables/MidFiPrototyping/Top%20Level-Navigation%20and%20Export.mp4) and for
2. the [unified panel editor](/Deliverables/MidFiPrototyping/Sidebar%20and%203D%20Model%20Import.mp4).

The former we designed in Sketch, following Apple's Human Interface Guidelines and drawing inspiration from other apps that foster organized productivity.
The latter we created in Figma, exploring how basic layering, the reference side panel, and context-switching to 3D template mode could work together.

In user testing, we primed the participants with a specific task, and observed their behavior. When they didn't know how to proceed, we provided them with a minimal hint.

In parallel, Cashen, Karl, and Alex participated as testers in groups 4, 7, and 10 respectively.

### Key Design Decisions for the Top Level-Navigation

- Force a flat structure upon the user: Every WORK consists of BOOKS which are segmented into CHAPTERS. A CHAPTER is a sequence of PANELS that belong together, forming a coherent story.\
  _Justification_: Jumping between subsequent panels should be effortless. With fixed semantic information, auto-export can work its magic with as little human input as possible.
  _Suspected Drawbacks_: Complex projects might deviate from this structure which might alienate potential users who will rather stick to traditional, file system-based software.
- Prioritize selection, export, and metadata. _Justification_: The panel editor should focus on the creative process, not on book-keeping. The latter must hence happen somewhere else. Users are conditioned to multi-select and share, as well as the infamous ellipses menus. _Suspected Drawbacks_: Feature discovery does not happen naturally. (Who clicks random buttons in the TLN anyway?)
- Display panels in various sizes. _Justification_: Make artists care about responsivity in their panels. Help discover the responsive layering feature. _Suspected Drawbacks_: Building muscle memory is harder when grid items are sized differently every time.
- Make the export sheet as simple as possible and hide complexities (e.g. custom preset creation) separate detail views. _Justification_: Editing presets happens very rarely. Most of the time, an artist only wants to quickly export to their existing platforms using one of their existing layouts. _Suspected Drawbacks_: None.

### Testing of the Top Level-Navigation

_Task_: "You are the creator of the beloved webcomic 'Imploding Kittens' and your fans on Tumbler, Tapas, and Parallax Viewer are eagerly awaiting the newest batch of content. Your task is to determine which panels you have drawn but not released yet and export those in a layout of your choosing."

_Feedback (5 participants)_:

- Three participants were not able to perform the first half of the task. Two participants suggested displaying a "NEW" badge next to unreleased panels for easy access. One participant suggested introducing an "Export Pending" button that performs this common task in one go.
- Two participants were confused by the ellipses menu next to each Book. They suggested splitting chapter quick-navigation from admin, e.g. by stacking quick-links horizontally under every book.
- One participant expressed that they would have liked to have a preview in the export sheet, e.g. in a separate view with a segmented control.

### Key Design Decisions for the Unified Panel Editor

- Keep the layer overview visible at all times. _Justification_: Because the size of a panel is constrained, we are left with more free room than other creative apps that store layers in a modal. Users will appreciate being able to quickly rearrange, hide, and switch to layers. _Suspected Drawbacks_: Users might accidentally select menu items while drawing. (Hence, the layer menu is on the left by default. The final product might allow switching its position for people with a left dominant hand.)

- Have a dedicated mode switch button leading to the 3D backdrop manipulation. _Justification_: Make the referencing purpose of 3D models clear to the user and separate them (and their tools) from the drawing facilities. _Suspected Drawbacks_: Beginners might get stuck in 3D-mode. (To combat this, we show both 3D and 2D layers in the same menu. We can imagine switching modes on layer switch too.)

- Place character logs, the scratchpad, and cross-referencing functionality into a unified space: the side panel. _Justification_: Separate planning from drawing while alleviating the need to multi-task to other apps to quickly look something up. _Suspected Drawbacks_: User might be confused about the side panel's intended functionality (as its content must be generated by the artist first).

- Use a recognizable, system-provided, brush panel. _Justification_: Special brushes are not part of our MVP, and will save an immense amount of time in the next prototyping phase. _Suspected Drawbacks_: Pro users are used to more features from existing creative apps (e.g. Procreate, Illustrator etc.)

### Testing of the Unified Panel Editor

_Task_: "You just got started drawing cartoons and are working on the third chapter of your webcomic 'Croc and Rhino.' In this panel, Rhino is celebrating its birthday, so you begin by drawing it looking at the reader. To achieve correct proportions and perspective, you decide to import a 3D-model of an actual rhino and place it behind your drawing. When it comes to drawing Rhino's age on the cake, you look its canonical value up in your scratchpad."

_Feedback (5 participants)_:

- All participants were confused by the lack of delete, move, and rotate buttons in the 3D toolbar.
- Two participants did not recognize what the side bar was for or were not aware of its existence.
- One participant deemed the appearing halves of the previous and next panel unnecessary and redundant, especially having seen the TLN concept before.
- One participant suggested that 3D-models should be linkable in the scratch-pad (e.g. one per character) and placable via drag and drop.
- One participant suggested the introduction of a speech bubble tool.
- One participant criticized the artistic restriction to panels, stressing the importance of free-flowing content between panels.

### Key Takeaways

The Top Level-Navigation conceptually works. Testers had no problems locating the latest chapter, selecting panels, and summoning the export sheet. Small tweaks, e.g. 'NEW' badges or quick links, could suffice to bring this experience to a satisfactory level.

The Unified Panel Editor in its current form lacks focus and struggles when it comes to feature discoverability. The plethora of mode switches and lack of UI uniformity underline the previous point. Hence, we believe that more work is required here.

Moving forward, we will consider TLN a low-priority area and focus on getting the editor experience just right by drastically simplify its intended functionality:

_The Unified Panel Editor provides the ability to_

1. _draw layered content using standard tools,_
2. _describe how layers should behave when the panel is resized,_
3. _ideate on one's story in a free-form scratchpad, and_
4. _temporarily place 3D models behind ones drawings for reference._

We enter the next stage with ideas for two potential A/B tests: one for (2) and one for (4). For the hi-fi prototype, we strive to build a minimally featured version of the editor with testing facilities for the desired test.

## Hi-fidelity Prototype

## User study

### Goal

Given that the core functionality of our app relies on sensibly responsive panels, we need to make editing the corresponding constraints discoverable and easy to use. We want the responsivity editor to

1. require minimal input, i.e. work with as little manual input as possible,
2. behave predicatably, i.e. extrapolate from the user's guidance like another human would, and
3. be flexible enough to achieve a wide range of results, i.e. allow the artist to express many layer alignments.

---

### Independent Variables

**(V1) Interface Variant**\
Drawing inspiration from existing paradigmns, we implement two alternative interface variants (independent):

(I) an indirect "pin" menu that allows the user to attach every layer to 9 points (corners, edge centers, panel center), and

(D) a direct "keyframe" mechanism that allows the user to drag layers to their desired position given the resizable panel's size.

**(V2) Task Type**\
To measure our goals, we task participants with

(C1) / (C2) making one of two preset panels responsive in such way that it mimicks the behavior from a video reference.

(O) making a preset panel responsive however they desire.

---

### Quantitative Dependent Variables

**(T) Task completion time**

**(N) Number of taps and drag gestures**

**(E) Number of erroneous inputs (i.e. missing or performing irrelevant inputs)**

**(A) Accuracy of the result (only for V2 ∈ {C1, C2})**

### Qualitative Dependent Variables

**(X) NASA TLX Score**

### Additional Qualitative Data

**A small set of custom questions on creativity, animation smoothness, joy of using, ...**

---

### Hypotheses

(HT) There will be no effect of input modality (V1) on the time (T) required to fulfill a closed task (V2 ∈ {C1, C2}).

(HN) There will be no effect of input modality (V1) on the number of gestures (N) required to fulfill a closed task (V2 ∈ {C1, C2}).

(HEA) There will be no effect of input modality (V1) on the overall accuracy (E/A) of the responsivity process in a closed task (V2 ∈ {C1, C2}).

(HX) There will be no effect of input modality (V1) on the TLX score (X) awarded by the users.

---

### Between-Subject Design

| IV Seq. ID | (V1,V2)1 | (V1,V2)2 |
| ---------- | -------- | -------- |
| 1          | (I,C1)   | (D,C2)   |
| 2          | (I,C2)   | (D,C1)   |
| 3          | (D,C1)   | (I,C2)   |
| 4          | (D,C2)   | (I,C1)   |

∀ V1, V2. (V1,V2) is preceded by training (V1,O).

---

### Protocol
{Information for the tester is in cury brackets {}} <br>
{We'll be testing our prototypes A and B on 8 or 12 people. The probands are identified uniquely as #i in (1, ..., 8/12) } <br>
### Introduction
Hi [#i's name]. Today we are looking for ways to improve the user experience of the responsivity editor in our drawing-app. With our responsivity editor we want to achieve the user to define how the layers should behave if he resizes the panel he's drawing on. Imagine being an artist who just drew a cartoon and you decide to change the panel aspect ratio. You're thinking the cartoon might look better if it spans the whole width of a page or you want to see how the drawing would look in an instagram post with an aspect ratio of 1:1. This is a test of the component; we are not testing you. If you find something difficult to use, chances are that others will as well, so your feedback helps everyone. This test of the component is simply a means of evaluating the component's design and to discover any issues we need to address.

The study will take about [nr minutes] minutes. We'll answer any questions you have in the end of the study.

We would like to make a video recording of the screen and your hands for evaluation purpose. To get your conscent we'd like you to sign the following form: [] (do we need other information?)

Do you have any questions?
Otherwise let's get started.

### Test
{Consider between subject design ((#i mod 4) + 1 )} <br>
{From now on, only }

In the next minutes you're asked to fulfill two tasks, each of them on a different version of our responsivity editor.
Before we introduce you to the specific task you're asked to get used to working with each of the versions for [y minutes] minutes.
We'll ansewer any questions you have about the app in the end of the study.

**(V1, V2)1:**

(Perhaps: Show an example of a task (C3) to lead them what they should try out in the following phase)

*open task 1:* <br>
 Here's our first version of the drawing app. Make sure to try out the reference mode by clicking on this button. You're given [y minutes] to try the app out, beginning now.

*main task 2:* <br>
As you can see on the IPad screen, you're given a preset. On the first layer there is [...], on the second [...]...
Now you're shown a video about how the different layers in the drawing should behave in the end when you're resizing the panel. You're asked to create the same behaviour when resizing the panel. You should try to be as accurate as possible, while also being fast. Before you begin with the task, push the button in the top right to start. If you're finished press the button on the top right again to stop.
(show video.)

**Questionnaire 1**<br>
**Q1) <br>Mental Demand:** How much mental and perceptual activity was required (e.g. thinking, deciding, calculating, remembering, looking, searching, etc.)? Was the task easy or demanding, simple or complex, exacting or forgiving?

**Q2) <br>Physical Demand:** How much physical activity was required (e.g. tapping, dragging, activating, etc.)? Was the task easy or demanding, slow or fast, restful or laborious, slack or strenous?

**Q3) <br> Performance:** How successful do you think you were in accomplishing the goals of the task set by us, i.e. matching our cartoon in different aspect ratios? How satisfied were with your performance in accomplishing these goals?

**Q4) <br> Effort:**
How hard did you have to work (mentally or physically) to accomplish your level of performance)?

**Q5) <br> Frustration Level:**
 How insecure, discouraged, irritated, stressed or annoyed versus secure, gratified, content, relaxed and complacent did you feel during the task?

**Q6) <br> Creativity:**
 Considering the 5 minutes you were given at the beginning, and the task you just completed, how much do you think the tool allows you to express your creativity? Is it restrictive or extensive, enabling or disabling?

**Q7) <br> Simplicity:** 
Again, considering your time with the tool sofar, how easy is it to use? How simple, effortless, straighforward versus complex, difficult, unintuitive was the use of the tool when accomplishing your goal.

**(V1, V2)2:** <br>
*open task 1:* <br>
Well done, now it's time for our second version: 
Again you should get used to the responsivity editor that has a new interface now. You'll get 5 min from now on.

*main task 2:* <br>
Again you'll get a preset and see a video of how the layers should behave when you resize the panel.
Before you begin with the task, push the button in the top right to start. If you're finished press the button on the top right again to stop.
(show video.)

**Questionnaire 2**<br>
**Q1) <br>Mental Demand:** How much mental and perceptual activity was required (e.g. thinking, deciding, calculating, remembering, looking, searching, etc.)? Was the task easy or demanding, simple or complex, exacting or forgiving?

**Q2) <br>Physical Demand:** How much physical activity was required (e.g. tapping, dragging, activating, etc.)? Was the task easy or demanding, slow or fast, restful or laborious, slack or strenous?

**Q3) <br> Performance:** How successful do you think you were in accomplishing the goals of the task set by us, i.e. matching our cartoon in different aspect ratios? How satisfied were with your performance in accomplishing these goals?

**Q4) <br> Effort:**
How hard did you have to work (mentally or physically) to accomplish your level of performance)?

**Q5) <br> Frustration Level:**
 How insecure, discouraged, irritated, stressed or annoyed versus secure, gratified, content, relaxed and complacent did you feel during the task?

**Q6) <br> Creativity:**
 Considering the 5 minutes you were given at the beginning, and the task you just completed, how much do you think the tool allows you to express your creativity? Is it restrictive or extensive, enabling or disabling?

**Q7) <br> Simplicity:** 
Again, considering your time with the tool sofar, how easy is it to use? How simple, effortless, straighforward versus complex, difficult, unintuitive was the use of the tool when accomplishing your goal.

**Questionair 3**<br>
**Q1) <br> Comparison:** 
(Open question)
Having used both methods, which one did you prefer? Which one of the key aspects (i.e. mental/physical demand, performance, etc.) in the questionaire was the main reason for your preference?

**Q2) <br> Keyframe experience:**
Do you have any previous experience with Keyframing, as seen in video-editing/animation software? 

**Q3) <br> Constraint based experience:**
Do you have any previous experiences with constraint based layouting, like in Figma or similar software? 

**Q4) <br> Improvements:**
Do you have any suggestions for points of improvements?








