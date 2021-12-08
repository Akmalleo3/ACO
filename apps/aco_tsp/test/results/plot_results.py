import matplotlib.pyplot as plt

from data import *

def convertToSecs(l):
    return list(map(lambda x : x/1000,l))



#########
#Plot bays29 scale with ants
#########
plt.plot(convertToSecs(bays29_29_time), bays29_29_cost, label='29 ants')
plt.plot(convertToSecs(bays29_60_time), bays29_60_cost, label='60 ants')
plt.plot(convertToSecs(bays29_120_time), bays29_120_cost, label='120 ants')
plt.plot(convertToSecs(bays29_240_time)[0:4], bays29_240_cost[0:4], label='240 ants')
plt.plot([1,52],[1955,1955], label='Minimal Cost')
plt.title("Distributed ACO Bays29 Performance")
plt.xlabel("Time (s)")
plt.ylabel("Tour Cost")
plt.legend()

plt.savefig("bays29_performance_vs_ants.jpg")


plt.clf()
#########
#Plot eil76 scale with ants
#########
plt.plot(convertToSecs(eil76_76_time), eil76_76_cost, label='76 ants')
plt.plot(convertToSecs(eil76_140_time), eil76_140_cost, label='140 ants')
plt.plot(convertToSecs(eil76_300_time), eil76_300_cost, label='300 ants')
plt.plot(convertToSecs(eil76_600_time[0:-1]), eil76_600_cost[0:-1], label='600 ants')
plt.plot([1,500],[532,532], label='Minimal Cost')
plt.title("Distributed ACO Eil76 Performance")
plt.xlabel("Time (s)")
plt.ylabel("Tour Cost")
plt.ylim([530,750])
plt.legend()

plt.savefig("eil76_performance_vs_ants.jpg")


plt.clf()
#########
#Plot ch130 scale with ants
#########
plt.plot(convertToSecs(ch130_130_time), ch130_130_cost, label='130 ants')
plt.plot(convertToSecs(ch130_260_time), ch130_260_cost, label='260 ants')
plt.plot(convertToSecs(ch130_500_time), ch130_500_cost, label='500 ants')
plt.plot(convertToSecs(ch130_1000_time[0:-1]), ch130_1000_cost[0:-1], label='1000 ants')
plt.plot([1,3500],[6045,6045], label='Minimal Cost')
plt.title("Distributed ACO Ch130 Performance")
plt.xlabel("Time (s)")
plt.ylabel("Tour Cost")
plt.legend()

plt.savefig("ch130_performance_vs_ants.jpg")

plt.clf()
#########
#Plot a280 scale with ants
#########
plt.plot(convertToSecs(a280_150_time), a280_150_cost, label='150 ants')
#plt.plot(convertToSecs(a280_280_time), a280_280_cost, label='280 ants')
plt.plot([1,10000],[2568,2568], label='Minimal Cost')
plt.title("Distributed ACO A280 Performance")
plt.xlabel("Time (s)")
plt.ylabel("Tour Cost")
plt.legend()

plt.savefig("a280_performance_vs_ants.jpg")


plt.clf()
##################################
#Plot Distributed Vs Serial bays29
##################################

fig, ((ax1,ax2),(ax3,ax4)) = plt.subplots(2,2)

ax1.plot(convertToSecs(bays29_29_time), bays29_29_cost, label='distributed')
ax1.plot(acopy_bays29_29_time, acopy_bays29_29_cost, label='serial')
ax1.set_xlabel("Time (Secs)")
ax1.set_ylabel("Tour cost")
ax1.legend()
ax1.set_title("29 ants")

ax2.plot(convertToSecs(bays29_60_time), bays29_60_cost, label='distributed')
ax2.plot(acopy_bays29_60_time, acopy_bays29_60_cost, label='serial')
ax2.set_xlabel("Time (Secs)")
ax2.set_ylabel("Tour cost")
ax2.legend()
ax2.set_title("60 ants")

ax3.plot(convertToSecs(bays29_120_time), bays29_120_cost, label='distributed')
ax3.plot(acopy_bays29_120_time, acopy_bays29_120_cost, label='serial')
ax3.set_xlabel("Time (Secs)")
ax3.set_ylabel("Tour cost")
ax3.set_title("120 ants")
ax3.legend()

ax4.plot(convertToSecs(bays29_240_time), bays29_240_cost, label='distributed')
ax4.plot(acopy_bays29_240_time, acopy_bays29_240_cost, label='serial')
ax4.legend()
ax4.set_title("240 ants")
ax4.set_xlabel("Time (Secs)")
ax4.set_ylabel("Tour cost")

ax1.label_outer()
ax2.label_outer()
ax3.label_outer()
ax4.label_outer()

fig.suptitle("Bays29 Serial Vs Distributed")
plt.savefig("bays29_serial_vs_dist.jpg")


plt.clf()
##########
#Plot Distributed Vs Serial eil76
##########
fig, ((ax1,ax2),(ax3,ax4)) = plt.subplots(2,2)

ax1.plot(convertToSecs(eil76_76_time), eil76_76_cost, label='distributed')
ax1.plot(acopy_eil76_76_time, acopy_eil76_76_cost, label='serial')
ax1.set_xlabel("Time (Secs)")
ax1.set_ylabel("Tour cost")
ax1.legend()
ax1.set_title("76 ants")

ax2.plot(convertToSecs(eil76_140_time), eil76_140_cost, label='distributed')
ax2.plot(acopy_eil76_150_time, acopy_eil76_150_cost, label='serial')
ax2.set_xlabel("Time (Secs)")
ax2.set_ylabel("Tour cost")
ax2.legend()
ax2.set_title("150 ants")

ax3.plot(convertToSecs(eil76_300_time), eil76_300_cost, label='distributed')
ax3.plot(acopy_eil76_300_time, acopy_eil76_300_cost, label='serial')
ax3.set_xlabel("Time (Secs)")
ax3.set_ylabel("Tour cost")
ax3.set_title("300 ants")
ax3.legend()

ax4.plot(convertToSecs(eil76_600_time), eil76_600_cost, label='distributed')
ax4.plot(acopy_eil76_600_time, acopy_eil76_600_cost, label='serial')
ax4.legend()
ax4.set_title("600 ants")
ax4.set_xlabel("Time (Secs)")
ax4.set_ylabel("Tour cost")

ax1.label_outer()
ax2.label_outer()
ax3.label_outer()
ax4.label_outer()

fig.suptitle("Eil76 Serial Vs Distributed")
plt.savefig("eil76_serial_vs_dist.jpg")

##########
#Plot Distributed Vs Serial ch130
##########
fig, ((ax1,ax2),(ax3,ax4)) = plt.subplots(2,2)

ax1.plot(convertToSecs(ch130_130_time), ch130_130_cost, label='distributed')
ax1.plot(acopy_ch130_130_time, acopy_ch130_130_cost, label='serial')
ax1.set_xlabel("Time (Secs)")
ax1.set_ylabel("Tour cost")
ax1.legend()
ax1.set_title("130 ants")

ax2.plot(convertToSecs(ch130_260_time), ch130_260_cost, label='distributed')
ax2.plot(acopy_ch130_260_time, acopy_ch130_260_cost, label='serial')
ax2.set_xlabel("Time (Secs)")
ax2.set_ylabel("Tour cost")
ax2.legend()
ax2.set_title("260 ants")

ax3.plot(convertToSecs(ch130_500_time), ch130_500_cost, label='distributed')
ax3.plot(acopy_ch130_500_time, acopy_ch130_500_cost, label='serial')
ax3.set_xlabel("Time (Secs)")
ax3.set_ylabel("Tour cost")
ax3.set_title("500 ants")
ax3.legend()

ax4.plot(convertToSecs(ch130_1000_time), ch130_1000_cost, label='distributed')
ax4.plot(acopy_ch130_1000_time, acopy_ch130_1000_cost, label='serial')
ax4.legend()
ax4.set_title("1000 ants")
ax4.set_xlabel("Time (Secs)")
ax4.set_ylabel("Tour cost")

ax1.label_outer()
ax2.label_outer()
ax3.label_outer()
ax4.label_outer()

fig.suptitle("Ch130 Serial Vs Distributed")
plt.savefig("ch130_serial_vs_dist.jpg")



##########
#Plot Distributed Vs Serial a280
##########
