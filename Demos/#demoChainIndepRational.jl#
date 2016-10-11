function demoChainIndepRational()

    println("In this demo we consider the directed graph A->B->C")
    println("The chain is such that A and B are dependent, B and C are dependent, yet A and C are independent.")
    println("To show this we will define the table entries using rationals. Julia will then use rational arithmetic for the subsequent calculations.")

    A,B,C=1,2,3
    pA=PotArray(A,[3//5, 2//5])
    pBgA=PotArray([B A],[1//4 15//40; 1//12 1//8; 2//3 1//2])
    pCgB=PotArray([C B],[1//3 1//2 15//40; 2//3 1//2 5//8])
    pABC=pCgB*pBgA*pA
    pAC=sum(pABC,B)
    pA=sum(pAC,C)
    pC=sum(pAC,A)

    println("pAC-pA*pC=")
    println(pAC-pA*pC)
    println("This shows that A and C are independent.\n")

    println("Contrast this with the same calculation using floating point arithmetic:")


    pA=PotArray(A,[3/5, 2/5])
    pBgA=PotArray([B A],[1/4 15/40; 1/12 1/8; 2/3 1/2])
    pCgB=PotArray([C B],[1/3 1/2 15/40; 2/3 1/2 5/8])
    pABC=pCgB*pBgA*pA
    pAC=sum(pABC,B)
    pA=sum(pAC,C)
    pC=sum(pAC,A)

    println("pAC-pA*pC=")
    println(pAC-pA*pC)
    println("The loss of numerical accuracy means that we cannot confidently declare A and C are independent, even though they actually are.")


end
