<!-- <p align="left" width="100%">
  <img height="56" src="img/logo-ait.png"> &nbsp; &nbsp;
  <img height="56" src="img/eth-sip-3l.png">
</p> -->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./img/siplab-ait-eth-logos-white.png">
  <img alt="SIPLAB and AIT at ETH Zürich." src="./img/siplab-ait-eth-logos.png" width="480">
</picture>

# Flex Studio, Group 1

#### Kai Zheng, Cashen Adkins, Tim Kluser, Karl Robert Kristenprun, Alexander Zank

![An overview of the responsivity tool in Flex Studio.](study/paper/Header.png)
_Background © ETH Zürich / Gian Marco Castelberg_

> Flex Studio is our semester project for ETH's HCI course.
> 
> #### Quick Links
>
> - our paper [_Designing and Evaluating a Responsivity Tool for Flex Studio_](/Deliverables/Study/Report.pdf)
> - our [final presentation](https://www.youtube.com/watch?v=SJYu8f-hb8Y)
> - a [guided video walkthrough](https://www.youtube.com/watch?v=o2dFzIIkwnU) of the hifi-prototype

## Project description

_Flex Studio_ is a concept application streamlining the workflow of cartoon and webcomic artists. Instead of focusing on full-page layouts, artists develop one panel at a time, letting their imagination run free while hinting to the system how their drawings should be positioned at a wide range of aspect ratios. Our auto-paneling technology uses this information to export single-panel, print, and full-page versions of their work tailored to each platform, alleviating the need for intensive manual composition work and increasing the reach of their art.

## Ideation & Evaluation

### Desk Research

Having selected "Cartoon" as our project topic, we first tried to find cartoon artists to give us some insight into their workflow and what they would like to see improved. Sadly, none of our posts on Reddit, nor E-Mails to cartoon networks, have been answered so far, so we relied on _existing conversations in creator lounges_, _existing applications in the field_, and on _blog posts_.

Before we entered the [desk research](/Deliverables/DeskResearch/DeskResearchSources.md), we already had some ideas of what we wanted to do, all revolving around a responsive cartoon-maker. But instead of following our initial ideas, desk research allowed us to see the abundance of flaws in the current workflow of cartoonists. It made us realize the scope of possibilities that we could pursue. Our sources indicate that webcomics are prone to die without innovation on both the creator and the consumer side. Artists often use general-purpose graphics software instead of specialized tools, and consumers seem to prefer more interactive content when consuming digital media.

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

![Our affinity diagram](/Deliverables/Brainstorm/AffinityDiagram.jpeg)

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

1. the [top level-navigation](/Deliverables/MidFiPrototyping/IdeaB/Top%20Level-Navigation%20and%20Export.mp4) and for
2. the [unified panel editor](/Deliverables/MidFiPrototyping/IdeaA/Sidebar%20and%203D%20Model%20Import.mp4).

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

We enter the next stage with ideas for a potential A/B tests for (2). In the hi-fi prototype, we strive to build a minimally featured version of the editor with a responsivity tool and testing facilities.

## Hi-fidelity Prototype

Flex Studio (Research Edition) features panel-wise navigation, layered drawing, two variants of the responsivity tool, and plentiful study-centered infrastructure.

To achieve a native look and natural pencil interactions, we decided to forego Unity and instead implement an iPadOS app using Apple's SDK. Notably, we used

- SwiftUI to declare most views, build organic animations, and orchestrate data flow reactively,
- PencilKit for the smooth pencil mechanics and the system-provided bottom draw tool picker,
- Core Data to persist application state to the disk, and
- OSLog to accumulate events during the study.

Please view the [guided video walkthrough](https://www.youtube.com/watch?v=o2dFzIIkwnU) to see Research Edition in action and read our paper [_Designing and Evaluating a Responsivity Tool for Flex Studio_](/Deliverables/Study/Report.pdf) to learn about the two interface variants.

## User study

### Goal

Given that the core functionality of our app relies on sensibly responsive panels, we need to make editing the corresponding constraints discoverable and easy to use. We want the responsivity editor to

1. work quickly and easily, i.e., require minimal manual input,
2. behave predicatably, i.e., extrapolate from the user’s guidance like another human would, and
3. be flexible enough to achieve a wide range of results, i.e., allow the artist to express many layer alignments.

---

### Independent Variables

**(V1) Interface Variant**\
Drawing inspiration from existing paradigmns, we implement two alternative interface variants (independent):

(I) an indirect "pin" menu that allows the user to attach every layer to 9 points (corners, edge centers, panel center), and

(D) a direct "keyframe" mechanism that allows the user to drag layers to their desired position given the resizable panel's size.

**(V2) Task Type**\
To measure our goals, we task participants with

(C1) / (C2) making one of two preset panels responsive in such way that it mimicks the behavior from a printed reference.

---

### Dependent Variables

**T (Task Completion Time, sec) ∈ ℝ interval**

**N (Number of Drags and Gestures) ∈ ℕ interval**

**E (Number of Erroneous Inputs) ∈ ℕ interval**

**X (Modified NASA TLX Raw Score) ∈ {10, 11, ..., 100} interval**

**R (Perceived Restrictivity) ∈ {1, 2, ..., 10} Likert, ordinal**

**C (Perceived Complexity) ∈ {1, 2, ..., 10}Likert, ordinal**

### Additional Qualitative Data

**A small set of custom questions on creativity, animation smoothness, joy of using, ...**

---

### Hypotheses

(HT) There will be no effect of interface variant (V1) on the time (T) required to fulfill a closed task (V2).

(HN) There will be no effect of interface variant (V1) on the number of gestures (N) required to fulfill a closed task (V2).

(HE) There will be no effect of interface variant (V1) on the input accuracy (E) of the responsivity process in a closed task (V2).

(HX) There will be no effect of interface variant (V1) on the Raw TLX score (X) awarded by the users.

(HR) There will be no effect of interface variant (V1) on the restrictivity (R) perceived by the user.

(HC) There will be no effect of interface variant (V1) on the complexity (C) perceived by the user.

---

### Within-Subjects Design

| IV Seq. ID | (V1,V2)1 | (V1,V2)2 |
| ---------- | -------- | -------- |
| 1          | (I,C1)   | (D,C1)   |
| 2          | (I,C2)   | (D,C2)   |
| 3          | (D,C1)   | (I,C1)   |
| 4          | (D,C2)   | (I,C2)   |

∀ V1, V2. (V1,V2) is preceded by open training on V1.

---

### Protocol

View the [entire protocol](/Deliverables/Study/protocol.md) in its separate document.

---

### Study Results

For a detailed report on the study results, please refer to sections 3 and 4 of our paper [_Designing and Evaluating a Responsivity Tool for Flex Studio_](/Deliverables/Study/Report.pdf).

#### Quantitive

**Completion Time:**
To compare the effect of the interface variant V1 on completion time T, we conducted a paired samples t-test. The mean difference between the two groups was not statistically significant and we failed to reject HT.

**Number of Gestures:**
To compare the effect of the interface variant V1 on the number of gestures N, we conducted a paired samples t-test. The mean difference between the two groups was not statistically significant and we failed to reject HN.

**Input Accuracy:**
To compare the effect of the interface variant V1 on the number of erroneous inputs E, we conducted a Wilcoxon signed-rank test. The mean difference between the two groups was statistically significant, indicating that the direct interface is less prone to erroneous inputs. HE can be rejected

**Raw TLX Score:**
To compare the effect of the interface variant V1 on raw TLX score X, we conducted a paired samples t-test. The mean difference between the two groups was not statistically significant and we failed to reject HX.

**Restrictivity:**
To compare the effect of the interface variant V1 on restrictivity R, we conducted a Wilcoxon signed-rank test. The mean difference between the two groups was statistically significant, indicating that the direct interface is is perceived as less restrictive. HR can be rejected.

**Complexity:**
To compare the effect of the interface variant V1 on complexity C, we conducted a Wilcoxon signed-rank test. The mean difference between the two groups was not statistically significant and we failed to reject HC.

#### Qualitative

6 out of 8 participants preferred the direct interface, while the other 2 participants saw advantages in both interfaces, depending on the user's experience.
4 participants thought that the indirect interface was easier to use and less mentally demanding, one of the them mentioned that the difference is negligible.
The key reason why participants preferred the direct interface was due to having more control over the position of the layers and therefore the look of the final image.
Lastly, one participant noted that the direct interface was easier to use since they didn't need to test its behavior by

#### Conclusion

We designed and evaluated pinning- and keyframe-based interface variants for Flex Studio’s responsivity tool, allowing artists to make their creations more adaptive.

While our empirical study did not find significant performance differences, it did deem the direct interface more expressive. From qualitative results, we learned that the level of control offered by keyframes was a vital factor in participants’ preferences, but the preciseness of pins is also desirable.

As a next step, we suggest exploring the idea of using both interfaces simultaneously to combine their respective strengths.

## Goodbye

Throughout the semester, we researched, debated, explained, implemented, questioned, answered, analyzed, adjusted, pitched, and presented. While challenging and stressful at times, the overall HCI process has proven engaging, fun, and worthwhile. The results speak for themselves: We are amazed by our colleagues' projects and proud of our product. Thank you for sticking with us.

<!-- fin -->
