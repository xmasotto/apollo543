# Apollo 543

**Team Members**: Xander Masotto, Narender Gupta, Aliya Burkit, and Ayush Jain

**Competition Description**: https://wiki.illinois.edu/wiki/display/jplteam/2015+Competition+Rules

**Technical Writeup**: https://drive.google.com/open?id=1CG7BWUleNi7K-9QpFHiYVMMt0T8eJlCr

### Problem Description

In this competition, our task was to identify safe landing sites on Mars. We are given a specification for what constitutes a safe landing site, which can be directly calculated from a DEM (Digital Elevation Map). 

The ground truth is given as a 1024x1024 image, with 255 = safe and 0 = unsafe. We are provided with a downsampled DEM (512x512), and a full-resolution image of the terrain (1024x1024). The goal is to use information from both the full-res image and the lower-res DEM to form a prediction.

### Solution

Whether a position is hazardous is a function of the orientation of the rover (w.r.t its footpads), and the height of all peaks (local maximas in the DEM).
* We compute the approximate orientation of the rover at each position, using a bicubic interpolated DEM
* We compute the approximate peak heights in two ways:
  * Directly using the bicubic interpolating DEM
  * Using shadow information in the image
* From this, we can compute two hazard predictions, for each type of peak estimate.

We feed these two predictions, along with other geometric features (surface roughness, surface angle, rover orientation, etc), into a boosted decision tree model. The intuition is: in certain situations, the DEM-based peak detection is more accurate, and in other situations, the image-based peak detection is better. We let machine learning figure out which situations to use which prediction.

Implementation was in Matlab.

### Results

**Highest score among all the teams:**: https://wiki.illinois.edu/wiki/display/jplteam/2015+Competition+Results

**2nd Place Overall**

<img src="https://i.imgur.com/GOGkwKn.png" width="400"/>
