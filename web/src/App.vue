<template>
    <v-app v-if="displaying" style="background: transparent;">
        <div id="hud" style="position: absolute; top: 0; left: 0; display: flex; align-items: center; flex-direction: column;">
            <div v-for="(status, id) in statusData">
                <div v-if="status.value > 0">
                    <v-progress-circular :model-value="status.value" size="40" class="ma-2" :color="status.value <= 20 ? 'red' : settings.statusColor">
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
                <v-card width="700" height="500" color="primary">
                    <v-card-title style="display: flex; justify-content: space-between; align-items: center;">
                        <span>Inställningar</span>

                        <div>
                            <v-btn icon color="primary" :elevation="0" @click="saveSettings()">
                                <v-tooltip
                                    activator="parent"
                                    location="bottom"
                                >Spara</v-tooltip>

                                <v-icon>mdi-content-save-all</v-icon>
                            </v-btn>

                            <v-btn icon color="primary" :elevation="0" @click="closeApp()">
                                <v-tooltip
                                    activator="parent"
                                    location="bottom"
                                >Stäng</v-tooltip>

                                <v-icon>mdi-close</v-icon>
                            </v-btn>
                        </div>
                    </v-card-title>

                    <v-card-text style="height: 84%; overflow-y: scroll;">
                        <div v-if="!pageLoaded" style="display: flex; justify-content: center; align-items: center; height: 40vh;">
                            <v-progress-circular size="100" indeterminate color="white"></v-progress-circular>
                        </div>

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
                                            v-model="settings.background"
                                            label="Med bakground"
                                            value="bakground"
                                        ></v-checkbox>

                                        <v-checkbox
                                            v-model="settings.background"
                                            label="Utan bakground"
                                            value="no-background"
                                        ></v-checkbox>
                                    </v-card-text>
                                </v-card>
                            </div>

                            <div>
                                <v-card width="300" height="230" color="accent">
                                    <v-card-title>Färger</v-card-title>

                                    <v-divider></v-divider>

                                    <v-card-text style="display: flex; flex-direction: column;">
                                        <v-autocomplete
                                            label="Välj färg"
                                            v-model="settings.statusColor"
                                            item-title="label"
                                            item-value="value"
                                            :items="colors"
                                        ></v-autocomplete>
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
            displaySettings: false,
            pageLoaded: false,

            shouldUpdate: true,

            isTalking: false, 

            colors: [], 

            settings: {},

            icons: {
                ['health']: {
                    icon: 'mdi-heart',
                },

                ['armor']: {
                    icon: 'mdi-shield',
                },

                ['hunger']: {
                    icon: 'mdi-food-apple',
                },

                ['thirst']: {
                    icon: 'mdi-cup-water',
                },

                ['voice']: {
                    icon: 'mdi-microphone-off',
                },
            }, 

            statusData: {}
        }), 

        methods: {
            sendMessage(event, data, callback) {
                fetch(`https://lowkey_statusui/${event}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify(data ? data : [])
                }).then(resp => resp.json()).then(resp => callback(resp));
            }, 

            closeApp() {
                this.sendMessage('closeApp', null, (resp) => {
                    this.displaySettings = false;
                })
            }, 

            saveSettings() {
                this.sendMessage('saveSettings', this.settings, (resp) => {
                    if (!resp.success) return; 

                    this.closeApp(); 
                })
            }
        }, 

        mounted() {
            window.addEventListener('message', (event) => {
                const { type, data } = event.data;

                if (type == 'init') {
                    this.settings = data.settings;
                }

                if (type === 'updateStatus') {
                    this.statusData = data;

                    this.isTalking = data.voice.isTalking
                    this.displaying = true;
                } 
                
                if (type == 'hide') {
                    this.displaying = false;
                }

                if (type == 'openSettings') {
                    this.displaySettings = true;

                    let newPromise = new Promise((resolve) => {
                        this.sendMessage('fetchSettings', null, (settings) => {
                            resolve(settings)
                        })
                    })

                    newPromise.then((results) => {
                        if (!results.success) return; 

                        this.settings = results.data.settings;
                        this.colors = results.data.colors;

                        this.pageLoaded = true; 
                    })
                }
            });

            document.addEventListener('DOMContentLoaded', function() {
                document.getElementById('hud').style.flexDirection = this.settings.layout;

                if (this.settings.background === 'bakground') {
                    document.getElementById('hud').style.background = 'rgba(0, 0, 0, 0.5)';
                    document.getElementById('hud').style.borderRadius = '50px';
                } else {
                    document.getElementById('hud').style.background = 'none';
                }

                document.getElementById('hud').style.top = `${this.settings.position.y}%`;
                document.getElementById('hud').style.left = `${this.settings.position.x}%`;
            });
        },

        watch: {
            isTalking: function (val) {
                this.icons['voice'].icon = val > 0 ? 'mdi-microphone' : 'mdi-microphone-off';
            }, 

            settings: {
                handler: function (val) {
                    if (val.position) {
                        document.getElementById('hud').style.top = `${val.position.y}%`;
                        document.getElementById('hud').style.left = `${val.position.x}%`;
                    }

                    if (val.layout) {
                        document.getElementById('hud').style.flexDirection = val.layout;
                    }

                    if (val.background) {
                        if (val.background === 'bakground') {
                            document.getElementById('hud').style.background = 'rgba(0, 0, 0, 0.5)';
                            document.getElementById('hud').style.borderRadius = '50px';
                        } else {
                            document.getElementById('hud').style.background = 'none';
                        }
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