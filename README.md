# Raytracing-FPGA

## Development Outline

Raytracing-FPGA (RT-FPGA) is the R&D of dedicated hardware specialized for 3D rendering, particulary for Blender. It aims to address problems
in accessibly for individual artists or small teams. 

In 3D animation, seconds of animations take hours, minutes take days or weeks. 
A personal ancedote involves our teams work on a project: for 180 frames (3 seconds, 60fps, cycles), it took 6 hours to render on a Nvidia RTX
4070. For long works, it would take years to finish rendering on time. The alternative for onsite rendering are online services, 
typically expensive.

As such, RT-FPGA aims to migitate these barriers. Through the development of a FPGA with goal of prototyping an ASIC, hardware accelerator
specific to the rendering pipeline can be achieved, reducing unnecessary components from the modern accelerator to reduce costs and improve
efficiency. 

Metrics determining the project's success are controlled by cost per performance as well as power consumption per frame. Setup will done
using methodologies highlighted by GamerNexus, with GPU TestBench 2023. Measurements will involve cost and efficiency in comparison to 
speculated top efficent and per dollar performance GPUs. This project defines success at 200% lead in cost-per-dollar and 
strong efficiency leads.

One way RT-FPGA brings unique value to the industry is through its principles of maintaining accessibility. Through customized pipelines, 
many 3D projects become accessible to many. It also largely reduces rendering costs for large clusters: significant power consumption
reductions and less demand. Like how the development of ASIC revolutionized cryptomining, this project aims to change 3D rendering.

RT-FPGA has many ways of letting potential consumers become aware of its beliefs and what it means. One of them is through peer-to-peer
relations involving teams interested in 3D pipeline. RT-FPGA helps realize successful projects, spreading awareness to individuals interested
in pursuing their own dream. Besides that, RT-FPGA has plans to host informative briefs to inform customers as well as sending newsletters.

An ideal customer requesting a RT-FPGA is one interested in pursuing large 3D works at low costs or high efficiency. 

Lastly, the costs involved in RT-FPGA include purchasing of FPGA boards (including Cyclone IV FPGAs), R&D of FPGA, incurred software costs
(potentially Intel Quartus for more device support), and testing hardware. The offset to these costs include selling of final, tested prototypes 
and offering of significantly lower than industry rate per minute costs of cloud rendering.
