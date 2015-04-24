f = open('testFeatures.log')

names = set()
ivals = set()
accuracy = {}
auc = {}

for line in f:
    name = line.split(']', 1)[0][1:]
    i = line.split(':', 1)[0].split()[-1]
    val = float(line.split(':', 1)[1].strip())

    names.add(name)
    ivals.add(i)

    if 'Accuracy' in line:
        k = (name, i)
        if k not in accuracy:
            accuracy[k] = (0, 0);
        s, cnt = accuracy[k]
        accuracy[k] = (s + val, cnt + 1)

    if 'AUC' in line:
        k = (name, i)
        if k not in auc:
            auc[k] = (0, 0);
        s, cnt = accuracy[k]
        auc[k] = (s + val, cnt + 1)

for name in names:
    total_accuracy = 0
    total_auc = 0
    for i in ivals:
        s, cnt = accuracy[(name, i)]
        avg = s / cnt
        total_accuracy += avg
        accuracy[(name, i)] = avg;

        s, cnt = auc[(name, i)]
        avg = s / cnt
        total_auc += avg
        auc[(name, i)] = avg;

    accuracy[name] = total_accuracy / len(ivals)
    auc[name] = total_auc / len(ivals)

for name in names:
    print('%s Average Accuracy: %f' % (name, accuracy[name]))
    print('%s Average AUC: %f' % (name, auc[name]))

    for i in ivals:
        print('%s Average Accuracy for %s: %f' % (name, i, accuracy[(name, i)]))
        print('%s Average AUC for %s: %f' % (name, i, auc[(name, i)]))
