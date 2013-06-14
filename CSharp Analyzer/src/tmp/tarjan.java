package tmp;


private int i = 0;
private Stack<String> s = new Stack<String>();


public void tarjan() {
    for(String v : neighbors.keySet()) {
        tarjanMap.put(v, new Integer[] { null, null});

                // tarjanMap.get(v)[0] - index
                // tarjanMap.get(v)[0] - lowlink
    }

    for(String v : neighbors.keySet()) {
        if(tarjanMap.get(v)[0] == null) {
            this.strongConnect(v);
        }
    }
}

public void strongConnect(String v) {
    tarjanMap.put(v, new Integer[] { i, i});
    i++;
    s.push(v);

    for(String w : getSuccessor(v)) {
        if(tarjanMap.get(w)[0] == null) {
            this.strongConnect(w);

            tarjanMap.put(v, new Integer[] { tarjanMap.get(v)[0], Math.min(tarjanMap.get(v)[1], tarjanMap.get(w)[1])});
        } else if(s.contains(w)) {
            tarjanMap.put(v, new Integer[] { tarjanMap.get(v)[0], Math.min(tarjanMap.get(v)[1], tarjanMap.get(w)[0])});
        }
    }

    if(tarjanMap.get(v)[1] == tarjanMap.get(v)[0]) {
        List<String> scc = new ArrayList<String>();

        String w;

        do {
            w = s.pop();
            scc.add(w);
        }while(w != v);

        System.out.println("Strongly Connected Components: ");          
        for (String c : scc) {
            System.out.println(c);
        }
    }
}
