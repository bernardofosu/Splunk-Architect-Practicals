Search Head Cluster (SHC) with at least 3 search heads can still operate as a search cluster if one of the search heads goes down, as long as there are still 2 search heads remaining operational.

In a 3-member SHC, the minimum requirement for quorum (which is the majority of search heads) is 2. As long as 2 search heads are active and can communicate with each other, the cluster will remain operational and continue functioning as a valid Search Head Cluster.

However, if the number of active search heads drops below 2 (e.g., only 1 search head remains), the SHC will lose its cluster status and cannot function as a Search Head Cluster anymore.

Summary:
3 search heads: Cluster remains operational if 1 goes down.

2 search heads: Cluster remains operational but loses its Search Head Cluster status.

1 search head: Cluster status is lost, and the remaining search head operates as a standalone.