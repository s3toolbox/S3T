function val = getPlateValue(plate,experiments )
        global plateIndex;
        global   firstExpNb;
        if 0
        plateIndex =[1:12;13:24;25:36;37:48;49:60;61:72;73:84;85:96]; 
        %plateIndex =[1:96]; 
        warning ('plateindex hacked')
        else
        plateIndex = [  ...
            85	86	87	88	89	90	91	92	93	94	95	96;
            73	74	75	76	77	78	79	80	81	82	83	84;
            61	62	63	64	65	66	67	68	69	70	71	72;
            49	50	51	52	53	54	55	56	57	58	59	60;
            37	38	39	40	41	42	43	44	45	46	47	48;
            25	26	27	28	29	30	31	32	33	34	35	36;
            13	14	15	16	17	18	19	20	21	22	23	24;
            1	2	3	4	5	6	7	8	9	10	11	12
            ];
        end
        for ii=1:length(experiments)
            val(ii) = plate.plateValues(plateIndex(:)==(plate.expwells(experiments(ii)+1-firstExpNb)));
        end
    end