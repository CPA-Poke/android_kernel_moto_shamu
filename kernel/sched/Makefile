ifdef CONFIG_FUNCTION_TRACER
CFLAGS_REMOVE_clock.o = -pg
endif

ifdef CONFIG_SCHED_BFS
obj-y += bfs.o clock.o
else
obj-y += core.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
obj-$(CONFIG_SCHED_DEBUG) += debug.o
obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
endif
obj-$(CONFIG_SMP) += cpupri.o
