function poset(adj, root)
#function [depth] = poset(adj, root)
#% POSET		Identify a partial ordering among the nodes of a graph
#%
#%  [DEPTH] = POSET(ADJ,ROOT)
#%
#% Inputs :
#%    ADJ : Adjacency Matrix
#%    ROOT : Node to start with
#%
#% Outputs :
#%    DEPTH : Depth of the Node
#%
#% Usage Example : [depth] = poset(adj,12);
#%
#%
#% Note     : All Nodes must be connected
#% See also #
#
#% Uses :
#
#% Change History :
#% Date		Time		Prog	Note
#% 17-Jun-1998	12:01 PM	ATC	Created under MATLAB 5.1.0.421

#% ATC = Ali Taylan Cemgil,
#% SNN - University of Nijmegen, Department of Medical Physics and Biophysics
#% e-mail : cemgil@mbfys.kun.nl

adj = adj+adj'

N = size(adj,1)
depth = zeros(N,1)
    depth[root] = 1
    queue=[]
    queue = vec(vcat(queue,root))

while true
  if isempty(queue)
    if all(depth.>0)
        break
    else
      root = find(depth.==0)
      root = root[1]
      depth[root] = 1
        queue=[]
        queue = vec(vcat(queue,root))
    end
  end
    r = queue[1]
    queue=vec(queue)
    shift!(queue)
  idx = find(adj[r,:])
  idx2 = find(depth[idx].==1);
  idx = idx[idx2]
  queue = vec(vcat(queue, idx))
  depth[idx] = depth[r]+1
end
    return depth
end

