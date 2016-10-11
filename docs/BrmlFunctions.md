# BrmlFunctions

## Exported

---

<a id="method__dicttoarray.1" class="lexicon_definition"></a>
#### DictToArray(D) [¶](#method__dicttoarray.1)
 Copies the dictionary **D** values into a new vector
 with the size equal to the number of keys in the dictionary


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:357](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L357)

---

<a id="method__sparseintmatrix.1" class="lexicon_definition"></a>
#### SparseIntMatrix(M, N) [¶](#method__sparseintmatrix.1)
 Initialises a new matrix of size **M x N**

* `M`:     number of rows
* `N`:     number of columns


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:34](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L34)

---

<a id="method__condexp.1" class="lexicon_definition"></a>
#### condexp(logp) [¶](#method__condexp.1)
 Computes **`p`** proportional to **`exp(log p)`**


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:427](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L427)

---

<a id="method__condp.1" class="lexicon_definition"></a>
#### condp(p) [¶](#method__condp.1)
 Creates a conditional distribution from an array

    pnew = condp(pin, varargin)

##### Input:
* `pin`:      a positive matrix
* `varargin`: optional input specifying which indices form the distribution variables

##### Output:
* `pnew`:    a new matrix with **`sum(pnew, 1) = ones(1, size(p, 2))`**

##### Example:
    r = rand(4, 2, 3); 
    p = condp(r, DistributionIndices=[3 1]);

**`p`** is now an array of the same size as **`r`**, but with **`sum(sum(p,3),1) = 1`** for each of the dimensions of the 2nd index.

*Note:*

**`p=condp(r,0)`** returns a normalised array **`p = r./sum(r(:))`**


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:400](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L400)

---

<a id="method__fillmatrix.1" class="lexicon_definition"></a>
#### fillmatrix!(A, indsi, indsj, val) [¶](#method__fillmatrix.1)
 Initialises a subarray of **`A`** with value **`val`**

* `A`:         array to fill
* `indsi`:     vector/range of row indeces
* `indsj`:     vector/range of column indeces
* `val`:       value to fill with the elements


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:47](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L47)

---

<a id="method__findmax.1" class="lexicon_definition"></a>
#### findmax(A, variables) [¶](#method__findmax.1)
 Maximises a multi-dimensional array over a set of dimensions
    
    [maxval maxstate] = findmax(A, variables)

* `A`:         array to fill
* `variables`: <???>

Finds the values and states that maximize the multi-dimensional
 array **`A`** over the dimensions in <???>maxover


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:312](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L312)

---

<a id="method__findone.1" class="lexicon_definition"></a>
#### findone(A, c) [¶](#method__findone.1)
 Returns the indices of the first element in matrix **`A`** that has the value **`c`**


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:188](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L188)

---

<a id="method__isavector.1" class="lexicon_definition"></a>
#### isavector(A) [¶](#method__isavector.1)
 Verifies if matrix **`A`** has one of the dimensions of size **1**


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:151](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L151)

---

<a id="method__istree.1" class="lexicon_definition"></a>
#### istree(A) [¶](#method__istree.1)
 Checks if the input graph is singly-connected (a polytree)

    [tree, elimseq, schedule] = istree(A, <root>=[]; <ReturnElimSeq>=false)

##### Input : 
* `A`: graph's adjacency matrix (zeros on diagonal)
* `root`: (_optional_) root node of the graph

##### Outputs:
* `tree`: _true_ if graph is singly connected, otherwise _false_
* `elimseq`: a variable elimination sequence in which simplical nodes of the tree are listed,
 as each simplical node is removed from the tree.
* `schedule`: the sequence of messages from node to node corresponding to elimseq

If **`A`** is a directed graph, the elimination schedule begins with the nodes with no children.
 If root is specified, the last node eliminated is root.

If the graph is connected and the number of edges is less than the number of nodes,
 it must be a tree. However, to deal with the general case in which it is unknown if the graph
 is connected w check using elimination.

A tree/singly-connected graph must admit a recursive simplical node elimination. That is at
 any stage in the elimination there must be a node with either 0 or 1 neighbours in the remaining graph.


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:244](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L244)

---

<a id="method__istree.2" class="lexicon_definition"></a>
#### istree(A, root) [¶](#method__istree.2)
 Checks if the input graph is singly-connected (a polytree)

    [tree, elimseq, schedule] = istree(A, <root>=[]; <ReturnElimSeq>=false)

##### Input : 
* `A`: graph's adjacency matrix (zeros on diagonal)
* `root`: (_optional_) root node of the graph

##### Outputs:
* `tree`: _true_ if graph is singly connected, otherwise _false_
* `elimseq`: a variable elimination sequence in which simplical nodes of the tree are listed,
 as each simplical node is removed from the tree.
* `schedule`: the sequence of messages from node to node corresponding to elimseq

If **`A`** is a directed graph, the elimination schedule begins with the nodes with no children.
 If root is specified, the last node eliminated is root.

If the graph is connected and the number of edges is less than the number of nodes,
 it must be a tree. However, to deal with the general case in which it is unknown if the graph
 is connected w check using elimination.

A tree/singly-connected graph must admit a recursive simplical node elimination. That is at
 any stage in the elimination there must be a node with either 0 or 1 neighbours in the remaining graph.


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:244](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L244)

---

<a id="method__maxarray.1" class="lexicon_definition"></a>
#### maxarray(A) [¶](#method__maxarray.1)
 Finds the largest non-zero value of matrix **`A`**


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:22](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L22)

---

<a id="method__memberinds.1" class="lexicon_definition"></a>
#### memberinds(x, y) [¶](#method__memberinds.1)
 Returns a vector mapping the indices of **`x`** and **`y`** for which the corresponding elements have the same value

* `x`:     item to compare
* `y`:     item to compare


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:118](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L118)

---

<a id="method__myipermutedims.1" class="lexicon_definition"></a>
#### myipermutedims{T<:AbstractArray{T, N}}(A::T<:AbstractArray{T, N}, d) [¶](#method__myipermutedims.1)
 Wrapper for **`ipermutedims`** used for backward compatibility
 from porting the MATLAB version of BRML code


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:343](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L343)

---

<a id="method__mysize.1" class="lexicon_definition"></a>
#### mysize(a) [¶](#method__mysize.1)
 Returns the size for each dimension of a vector or matrix

* `a`:     vector or matrix to analyse


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:100](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L100)

---

<a id="method__myvcat.1" class="lexicon_definition"></a>
#### myvcat(x, y) [¶](#method__myvcat.1)
 Wrapper for standard **`vcat`** used for
 backward compatibility from porting the MATLAB version of BRML code


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:135](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L135)

---

<a id="method__neighboursize.1" class="lexicon_definition"></a>
#### neighboursize(A) [¶](#method__neighboursize.1)
 Returns the number of neighbours in an graph

     nsize = neighboursize(A,<node>)

* `A`: adjacency matrix of the graph
* `node`: (_optional_) the node for which to find the number of neighbours

If **`node`** is missing, return the neighbour sizes (including self) of each node.
If **`A`** is directed, returns the number of parents of the specified node.


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:209](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L209)

---

<a id="method__neighboursize.2" class="lexicon_definition"></a>
#### neighboursize(A, nodes) [¶](#method__neighboursize.2)
 Returns the number of neighbours in an graph

     nsize = neighboursize(A,<node>)

* `A`: adjacency matrix of the graph
* `node`: (_optional_) the node for which to find the number of neighbours

If **`node`** is missing, return the neighbour sizes (including self) of each node.
If **`A`** is directed, returns the number of parents of the specified node.


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:209](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L209)

---

<a id="method__numstates.1" class="lexicon_definition"></a>
#### numstates(A) [¶](#method__numstates.1)
 Returns the number of elements of matrix **`A`**


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:167](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L167)

---

<a id="method__randgen.1" class="lexicon_definition"></a>
#### randgen(p) [¶](#method__randgen.1)
 Returns a random value from distribution **`p`**


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:332](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L332)

---

<a id="method__standardise.1" class="lexicon_definition"></a>
#### standardise{T<:Number}(A::Array{T<:Number, N}) [¶](#method__standardise.1)
 Transforms an one-dimensional array **`A`** of numerical values into a column vector,
  otherwise it leaves the input unchanged


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:86](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L86)

---

<a id="method__states.1" class="lexicon_definition"></a>
#### states(ns) [¶](#method__states.1)
 Enumerates all states given the number of states of each variable from a given set similar to MATLAB _ind2subv_

* `ns`:    vector with the total number of states for each variable


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:62](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L62)

---

<a id="method__vec.1" class="lexicon_definition"></a>
#### vec(v::Integer) [¶](#method__vec.1)
 Creates a vector with 1 element of value v


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:14](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L14)

## Internal

---

<a id="method__replace.1" class="lexicon_definition"></a>
#### replace!(A, f, r) [¶](#method__replace.1)
 Finds the elements having value **`f`** in matrix **`A`** and replaces their value with **`r`**


*source:*
[/Users/elfflorin/Documents/Projects/julia.hw/jpie/src/BrmlFunctions.jl:180](https://github.com/davidbarber/JuliaProbabilisticInferenceEngine/tree/b469ac67586c10247ab2baeeb0aeda089f041694/src/BrmlFunctions.jl#L180)

