Attention-deficit/hyperactivity disorder (ADHD) is associated with difficulties in attention and 
cognitive control. In this project, we investigate whether EEG recorded during a
visual-attention task contains information that can distinguish children with ADHD from
healthy controls at the participant level.
The dataset from Kaggle (https://www.kaggle.com/datasets/danizo/eeg-dataset-for-adhd) contains EEG recordings from 121 children, including 61 children with ADHD
and 60 controls. EEG was recorded from 19 channels. During the experiment, children
viewed images containing cartoon characters and were asked to count them. The next
image appeared immediately after the child's response. Consequently, the total recording
duration depended on task performance and response speed. This creates an important
methodological issue: recording length may itself contain behavioral information and must
not accidentally become a shortcut for the EEG classifier.
Research question: Can participant-level ADHD status be predicted from EEG recorded
during a visual-attention task and how much discriminative information is provided by
time-domain, frequency-domain and coarse temporal-position features?

Some notebooks were originally developed in Google Colab environments.
Before running the code, replace any placeholder file or folder paths with the corresponding paths on your system.
