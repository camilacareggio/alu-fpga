# TP1: ALU
## Arquitectura de Computadoras

### Consigna
Implementar en FPGA Basys3 una ALU.
- La ALU debe ser parametrizable (bus de datos) para poder ser utilizada posteriormente en el trabajo final.
- Validar el desarrollo por medio de Test Bench.
- El testbench debe incluir generación de entradas aleatorias y código de chequeo automático.
- Simular el diseño usando las herramientas de simulación de vivado incluyendo análisis de tiempo.

Los códigos para realizar operaciones son:

| Operación     | Código    | 
|---------------|-----------|
| ADD           | 100000    | 
| SUB           | 100010    | 
| AND           | 100100    | 
| OR            | 100101    |
| XOR           | 100110    |
| SRA           | 000011    |
| SRL           | 000010    | 
| NOR           | 100111    | 


### Esquemas
#### Del código

#### De _complete_alu_

#### De _alu_

### Testbench
Luego de su ejecución observamos las señales:

En el punto 1, vemos como se van cargando los valores de A, B y la operación con cada flaco positivo del clock.
Luego de la carga de esos tres valores, en el próximo flanco positivo del clock (punto 2) veremos el resultado de la alu, que coincide con el resultado esperado.
Cada vez que se carga otro dato u operación, el resultado se recalcula en el próximo flanco positivo.

También por consola vemos que funciona correctamente:

Y por último en la placa: