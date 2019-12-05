Spatial-temporal analysis: Proportions + Count plots
================
Rachel Smith & Brandon Sansom
Update on 12/04/2019

### Exploratory plots of space/time variables:

#### Contingency tables:

*Study Spatial Extent vs. Event Spatial Extent:*

Here, rows are Study Spatial Extent and columns are Event Spatial
extent.

    ##                       ProximateEvent_SpatialExtent
    ## Study_SpatialExtent    <1 sq m >1000 sq m 10-100 sq m 100-1000 sq m
    ##   <1 sq m                    0          1           0             0
    ##   >1000 sq m                 0         88           0             0
    ##   1-10 sq m                  1          3           0             0
    ##   10-100 sq m                0          5          17             2
    ##   100-1000 sq m              0          6           0             0
    ##   Regional/Continental       0          1           0             0
    ##   undefined                  0          0           0             0
    ##                       ProximateEvent_SpatialExtent
    ## Study_SpatialExtent    Regional/Continent
    ##   <1 sq m                               0
    ##   >1000 sq m                           25
    ##   1-10 sq m                             7
    ##   10-100 sq m                           0
    ##   100-1000 sq m                         1
    ##   Regional/Continental                 25
    ##   undefined                             7

    ##                       ProximateEvent_SpatialExtent
    ## Study_SpatialExtent        <1 sq m  >1000 sq m 10-100 sq m 100-1000 sq m
    ##   <1 sq m              0.000000000 0.005291005 0.000000000   0.000000000
    ##   >1000 sq m           0.000000000 0.465608466 0.000000000   0.000000000
    ##   1-10 sq m            0.005291005 0.015873016 0.000000000   0.000000000
    ##   10-100 sq m          0.000000000 0.026455026 0.089947090   0.010582011
    ##   100-1000 sq m        0.000000000 0.031746032 0.000000000   0.000000000
    ##   Regional/Continental 0.000000000 0.005291005 0.000000000   0.000000000
    ##   undefined            0.000000000 0.000000000 0.000000000   0.000000000
    ##                       ProximateEvent_SpatialExtent
    ## Study_SpatialExtent    Regional/Continent
    ##   <1 sq m                     0.000000000
    ##   >1000 sq m                  0.132275132
    ##   1-10 sq m                   0.037037037
    ##   10-100 sq m                 0.000000000
    ##   100-1000 sq m               0.005291005
    ##   Regional/Continental        0.132275132
    ##   undefined                   0.037037037

*Sampling Unit Spatial Extent vs. Event Spatial Extent:*

Here, rows are Sampling Unit Spatial Extent and columns are Event
Spatial extent.

    ##                           ProximateEvent_SpatialExtent
    ## SamplingUnit_SpatialExtent <1 sq m >1000 sq m 10-100 sq m 100-1000 sq m
    ##         <1 sq m                  1         31           0             0
    ##         >1000 sq m               0         16           0             0
    ##         1-10 sq m                0          6          13             2
    ##         10-100 sq m              0          9           4             0
    ##         100-1000 sq m            0         25           0             0
    ##         Regional/Continent       0          0           0             0
    ##         undefined                0         17           0             0
    ##                           ProximateEvent_SpatialExtent
    ## SamplingUnit_SpatialExtent Regional/Continent
    ##         <1 sq m                            22
    ##         >1000 sq m                          4
    ##         1-10 sq m                          23
    ##         10-100 sq m                         3
    ##         100-1000 sq m                       1
    ##         Regional/Continent                  5
    ##         undefined                           7

    ##                           ProximateEvent_SpatialExtent
    ## SamplingUnit_SpatialExtent     <1 sq m  >1000 sq m 10-100 sq m
    ##         <1 sq m            0.005291005 0.164021164 0.000000000
    ##         >1000 sq m         0.000000000 0.084656085 0.000000000
    ##         1-10 sq m          0.000000000 0.031746032 0.068783069
    ##         10-100 sq m        0.000000000 0.047619048 0.021164021
    ##         100-1000 sq m      0.000000000 0.132275132 0.000000000
    ##         Regional/Continent 0.000000000 0.000000000 0.000000000
    ##         undefined          0.000000000 0.089947090 0.000000000
    ##                           ProximateEvent_SpatialExtent
    ## SamplingUnit_SpatialExtent 100-1000 sq m Regional/Continent
    ##         <1 sq m              0.000000000        0.116402116
    ##         >1000 sq m           0.000000000        0.021164021
    ##         1-10 sq m            0.010582011        0.121693122
    ##         10-100 sq m          0.000000000        0.015873016
    ##         100-1000 sq m        0.000000000        0.005291005
    ##         Regional/Continent   0.000000000        0.026455026
    ##         undefined            0.000000000        0.037037037

*Sampling Duration Before vs. Event Duration:*

Here, rows are Sampling Duration Before and columns are Event Duration
extent.

    ##                         ProximateEvent_Duration
    ## Sampling_Duration_Before days hours months weeks years
    ##            days             3     6      0     0     0
    ##            months           5     0     26     9     0
    ##            none             1     0     28     3    20
    ##            single sample    0     0      1     3     0
    ##            weeks            0     0      1     0     0
    ##            years           15    10     39     4    23

*Sampling Duration During vs. Event Duration:*

Here, rows are Sampling Duration During and columns are Event Duration
extent.

    ##                         ProximateEvent_Duration
    ## Sampling_Duration_During days hours months weeks years
    ##            days             3    10      0     0     0
    ##            hours            1     0      6     0     0
    ##            months           1     0     52     8     7
    ##            none             7     0     28     3     1
    ##            single sample    0     6      4     3    16
    ##            weeks            0     0      1     2     0
    ##            years           12     0      4     3    19

*Sampling Duration After vs. Event Duration:*

Here, rows are Sampling Duration After and columns are Event Duration
extent.

    ##                        ProximateEvent_Duration
    ## Sampling_Duration_After days hours months weeks years
    ##           days             3     0      0     0     0
    ##           months           2     0     42     9     7
    ##           none            11     0     11     1    13
    ##           single sample    0     0      3     6     0
    ##           weeks            0     6      2     0     0
    ##           years            8    10     37     3    23

#### Heat Maps:

*Study Spatial Extent vs. Event Spatial Extent- as a proportion:*
![](time_spatial_proportions_files/figure-gfm/sample2-1.png)<!-- -->

#### Count Summaries:

*Study Spatial Extent + Event Spatial Extent:*
![](time_spatial_proportions_files/figure-gfm/spatial%20extent-1.png)<!-- -->

*Sampling Unit Spatial Extent vs. Event Spatial
Extent:*

![](time_spatial_proportions_files/figure-gfm/sample%20extent-1.png)<!-- -->

*Sampling Duration Before vs. Event
Duration:*

![](time_spatial_proportions_files/figure-gfm/sample%20before-1.png)<!-- -->

*Sampling Duration During vs. Event
Duration:*

![](time_spatial_proportions_files/figure-gfm/sample%20during-1.png)<!-- -->

*Sampling Duration After vs. Event
Duration:*

![](time_spatial_proportions_files/figure-gfm/sample%20after-1.png)<!-- -->
