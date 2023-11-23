<template>
    <v-app v-if="displaying" style="background: black;">
        <div id="hud" style="position: absolute; top: 0; left: 0; display: flex; align-items: center; flex-direction: column;">
            <div v-for="(status, id) in statusData">
                <div v-if="status.value > 0">
                    <v-progress-circular :model-value="status.value" size="40" class="ma-2" :color="status.value <= 20 ? 'red' : icons[id].color">
                        <template #default="{ value }">
                            <div>
                                <v-icon style="font-size: 17px;">{{ icons[id].icon }}</v-icon>
                            </div>
                        </template>
                    </v-progress-circular>
                </div>
            </div>
        </div>

        <div v-if="displaySettings">
            <div style="display: flex; justify-content: center; align-items: center; height: 100vh;">
                <v-card width="670" height="500" color="primary">
                    <v-card-title>Inställningar</v-card-title>
                    <v-card-subtitle>Ändra inställningar för din status hud</v-card-subtitle>

                    <v-card-text style="height: 84%; overflow-y: scroll;">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; grid-gap: 30px; grid-area: auto; place-items: center;">
                            <div>
                                <v-card width="300" color="accent" height="230">
                                    <v-card-title>Position</v-card-title>

                                    <v-divider></v-divider>

                                    <v-card-text>
                                        <div>
                                            <div class="text-caption">X</div>
                                            <v-slider v-model="settings.position.x" :max="100" :min="0" step="1" thumb-label></v-slider>
                                        </div>

                                        <div>
                                            <div class="text-caption">Y</div>
                                            <v-slider v-model="settings.position.y" :max="100" :min="0" step="1" thumb-label></v-slider>
                                        </div>
                                    </v-card-text>
                                </v-card>
                            </div>

                            <div>
                                <v-card width="300" height="230" color="accent">
                                    <v-card-title>Layout</v-card-title>

                                    <v-divider></v-divider>

                                    <v-card-text style="display: flex; flex-direction: column;">
                                        <v-checkbox
                                            v-model="settings.layout"
                                            label="Vertikal"
                                            value="column"
                                        ></v-checkbox>

                                        <v-checkbox
                                            v-model="settings.layout"
                                            label="Horisontell"
                                            value="row"
                                        ></v-checkbox>
                                    </v-card-text>
                                </v-card>
                            </div>

                            <div>
                                <v-card width="300" height="230" color="accent">
                                    <v-card-title>Bakgrund</v-card-title>

                                    <v-divider></v-divider>

                                    <v-card-text style="display: flex; flex-direction: column;">
                                        <v-checkbox
                                            v-model="settings.layout"
                                            label="Vertikal"
                                            value="column"
                                        ></v-checkbox>

                                        <v-checkbox
                                            v-model="settings.layout"
                                            label="Horisontell"
                                            value="row"
                                        ></v-checkbox>
                                    </v-card-text>
                                </v-card>
                            </div>
                        </div>
                    </v-card-text>
                </v-card>
            </div>
        </div>
    </v-app>
</template>

<script>
    export default {
        name: 'App',

        data: () => ({
            displaying: true, 
            displaySettings: true,
            isTalking: false, 

            settings: {
                position: {
                    x: 0,
                    y: 0,
                }, 

                layout: 'column'
            },

            icons: {
                ['health']: {
                    icon: 'mdi-heart',
                    color: 'white', 
                },

                ['armor']: {
                    icon: 'mdi-shield',
                    color: 'white',
                },

                ['hunger']: {
                    icon: 'mdi-food-apple',
                    color: 'white',
                },

                ['thirst']: {
                    icon: 'mdi-cup-water',
                    color: 'white',
                },

                ['voice']: {
                    icon: 'mdi-microphone-off',
                    color: 'white',
                },
            }, 

            statusData: {
                ['health']: {
                    value: 100,
                },

                ['armor']: {
                    value: 100,
                },

                ['hunger']: {
                    value: 100,
                },

                ['thirst']: {
                    value: 100,
                },

                ['voice']: {
                    value: 100,
                },
            }
        }), 

        mounted() {
            // window.addEventListener('message', (event) => {
            //     const { type, data } = event.data;

            //     if (type === 'updateStatus') {
            //         this.statusData = data;

            //         this.isTalking = data.voice.isTalking
            //         this.displaying = true;
            //     } 
                
            //     if (type == 'hide') {
            //         this.displaying = false;
            //     }
            // });
        },

        watch: {
            isTalking: function (val) {
                this.icons['voice'].icon = val > 0 ? 'mdi-microphone' : 'mdi-microphone-off';
            }, 

            settings: {
                handler: function (val) {
                    console.log(JSON.stringify(val))

                    if (val.position) {
                        document.getElementById('hud').style.top = `${val.position.y}%`;
                        document.getElementById('hud').style.left = `${val.position.x}%`;

                        console.log('Position changed');
                    }

                    if (val.layout) {
                        document.getElementById('hud').style.flexDirection = val.layout;

                        console.log('Layout changed');
                    }
                }, 

                deep: true,
            }
        }
    }
</script>

<style>
    ::-webkit-scrollbar {
        display: none;
    }
</style>