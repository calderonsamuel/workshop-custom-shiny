# Workshop: Creando inputs y outputs personalizados para Shiny

Este repositorio contiene el material del workshop "Creando inputs y outputs personalizados para Shiny" para LatinR 2025.

## Descripción del Workshop

**Duración:** 90 minutos
**Formato:** Virtual, práctico
**Nivel:** Usuarios intermedios de R/Shiny

### Lo que construirás

1. **Tri-State Toggle Input** — Un botón de múltiples estados que cicla entre tres opciones (ej: Todos / Activos / Completados)
2. **Stat Card Output** — Una tarjeta de métricas con estilos condicionales basados en umbrales

### Objetivos de aprendizaje

- Entender cómo el sistema de bindings de JavaScript de Shiny conecta el navegador con el servidor R
- Construir un input binding personalizado funcional
- Construir un output binding personalizado funcional
- Conocer recursos para implementaciones más avanzadas

## Prerrequisitos

- **R:** Versión 4.0 o superior
- **RStudio:** Versión 2023.06 o superior (recomendado)
- **Paquetes R:** `shiny`, `bslib`, `htmltools`, `dplyr`
- **Experiencia:** Comodidad construyendo apps básicas de Shiny (entiende `ui`, `server`, reactividad)
- **JavaScript/CSS:** Experiencia mínima esperada (el código inicial está muy comentado)

## Instrucciones de configuración

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd workshop-custom-shiny
```

### 2. Instalar paquetes requeridos

Abre R o RStudio y ejecuta:

```r
install.packages(c("shiny", "bslib", "htmltools", "dplyr"))
```

### 3. Verificar tu configuración

Abre `00-demo-finished/app.R` en RStudio y haz clic en **Run App**. Deberías ver:

- Un botón toggle de tres estados con tres opciones
- Una tarjeta de estadísticas que cambia de color según el valor del slider

**Lista de verificación:**

- [ ] La app se inicia sin errores
- [ ] Al hacer clic en el toggle se actualiza el valor del filtro mostrado
- [ ] Al mover el slider cambia el color de la tarjeta (verde/amarillo/rojo)

¡Si todo funciona, estás listo para el workshop!

## Estructura del repositorio

```
workshop-custom-shiny/
├── README.md                     # Este archivo
├── 00-demo-finished/             # App terminada mostrando ambos componentes
│   └── app.R
├── 01-input-starter/             # Ejercicio de input (completarás el JS)
│   ├── app.R
│   ├── R/
│   │   └── triStateInput.R
│   └── www/
│       ├── css/
│       │   └── tristate.css
│       └── js/
│           └── tristate.js       # <- Completa este archivo
├── 02-input-solution/            # Solución del ejercicio de input
│   └── ...
├── 03-output-starter/            # Ejercicio de output (completarás el JS)
│   ├── app.R
│   ├── R/
│   │   └── statCard.R
│   └── www/
│       ├── css/
│       │   └── statcard.css
│       └── js/
│           └── statcard.js       # <- Completa este archivo
├── 04-output-solution/           # Solución del ejercicio de output
│   └── ...
└── reference/
    └── resources.md              # Lecturas adicionales y referencias
```

## Ejercicios del Workshop

### Ejercicio 1: Custom Input Binding (40 min)

Navega a `01-input-starter/` y abre `www/js/tristate.js`. Implementarás:

1. `find(scope)` — Localizar todos los elementos tri-state input
2. `getValue(el)` — Extraer el valor seleccionado actual
3. `subscribe(el, callback)` — Manejar eventos de clic
4. `setValue(el, value)` y `receiveMessage(el, data)` — Soportar actualizaciones desde R

### Ejercicio 2: Custom Output Binding (20 min)

Navega a `03-output-starter/` y abre `www/js/statcard.js`. Implementarás:

1. `find(scope)` — Localizar todos los elementos stat card
2. `renderValue(el, data)` — Renderizar datos recibidos desde R

## Solución de problemas

| Problema | Solución |
|----------|----------|
| La app no corre | Verifica que el directorio de trabajo esté en la carpeta del ejercicio |
| Los cambios no aparecen | Refresca el navegador (Ctrl+Shift+R / Cmd+Shift+R) |
| Error de JavaScript en consola | Verifica comas/puntos y coma faltantes en el objeto binding |
| El valor del input es undefined en R | Verifica que `getValue()` tenga un `return` explícito |

## Recursos

- [Posit: How to Create Custom Input Bindings](https://shiny.posit.co/r/articles/build/js-custom-input/)
- [Posit: Build Custom Output Objects](https://shiny.posit.co/r/articles/build/building-outputs/)
- [Outstanding User Interfaces with Shiny](https://unleash-shiny.rinterface.com/) por David Granjon
- [JavaScript for R](https://javascript-for-r.com/) por John Coene

## Licencia

MIT
